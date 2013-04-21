class Listing < ActiveRecord::Base
  attr_accessible :active, :address, :slug, :description, :employees, :founders, :hiring, :featured, :hiringurl, :listeremail, :listername, :logo, :name, :url, :twitter

  private
	  # Validate Name
	  validate :validate_inputs
	  def validate_inputs
	  	# address removed as required
	  	[[:listername, self.listername], [:name, self.name], [:description, self.description], [:url, self.url]].each do |symb, val|
	  		errors.add(symb, "cannot be empty") if val.nil? or val.empty?
	  	end
	  end

	  # Validate URL & Hiring URL
	  validate :is_url_valid
	  def is_url_valid
	  	regex = URI::regexp(%w(http https))

	  	errors.add(:url, "cannot be recognized") if regex.match(self.url).nil?
	  	errors.add(:hiringurl, "cannot be recognized") if self.hiring == true and regex.match(self.hiringurl).nil?
	  end

	  # Validate Upload
	  validate :is_logo_valid
	  def is_logo_valid
	  	regex = URI::regexp(%w(http https))
	  	errors.add(:logo, "is not a valid URL") if regex.match(self.logo).nil?
	  end

	  # Twitter
	  validate :twitter_valid
	  def twitter_valid
	  	return if self.twitter.to_s.length == 0
	  	errors.add(:twitter, "must be formatted as @username") unless self.twitter.to_s[0...1] == "@"
	  end

	  # Validate Lister Email
	  validate :listeremail_valid
	  def listeremail_valid
	  	errors.add(:listeremail, "cannot be recognized") unless /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/.match(self.listeremail)
	  end

	  # Validate Employees
	  validate :employee_input_check
	  def employee_input_check
	  	errors.add(:employees, " must be provided") if self.employees.to_s.eql?("Please Select")
	  end

	  # Before Save, Add Slug
	  before_save :add_slug
	  def add_slug
	  	self.slug = self.name.parameterize if self.slug.to_s.empty?
	  end

	  # Delete S3 logo goodness
	  before_destroy :remove_s3_logo
	  def remove_s3_logo
	  	@bucket = 'builtinmcr-assets'
	  	@file = URI::parse(self.logo).path[@bucket.length+2..-1] # added 2 for the trailing slashes /builtinmcr-assets/:file.png
	  	AWS::S3::S3Object.find(@file, @bucket).delete
	  end

	  # Delete tags
	  after_destroy :remove_tags
	  def remove_tags
	  	Tag.where(:listing => self.id).destroy_all
	  end

  # Extensible methods to Listing
  public

      # Search
      def self.search(query)
        self.where("LOWER(`name`) LIKE (?)", "%#{query.downcase}%")
      end

      # By tag
      def self.by_tag(tag)
        t = Tag.where(:name => tag.downcase)

        if t.count > 0 then
          ids = []
          t.all.each do |tag|
            ids.push(tag.listing) unless ids.include?(tag.listing)
          end

          self.where(:id => ids, :active => true).order("featured ASC")
        end
      end

  	  # Get hostname of domain (http://www.facebook.com/ -> facebook.com)
  	  def host
  	  	return if self.url.nil?
  	  	host = URI.parse(self.url).host
  	  	host = host[4..-1] if host[0..3].eql?("www.")
  	  	host || nil
  	  end

  	  # Tags in an array
  	  def tags
  	  	return if self.id.nil?
  	  	@tags || (@tags = Tag.where(:listing => self.id).all) || nil
  	  end

      # Tags in comma separated form
      def comma_tags
        res = []
        self.tags.each do |tag|
          res.push(tag.name)
        end

        res.join(', ')
      end

      # When updating comma tags, call .update_comma_tags
      def update_comma_tags(input)
        return if self.id.nil? # Disable if not saved

        Tag.where(:listing => self.id).delete_all
        if input.include?(', ') then
          input.split(', ').each do |tag|
            self.insert_tag(tag)
          end
        else
          self.insert_tag(input)
        end

      end

  	  # Insert Tag
  	  def insert_tag(name)
        return if self.id.nil? # Disable if not saved
  	  	return if Tag.where(:listing => self.id, :name => name).count > 0
        t = Tag.create!(:listing => self.id, :name => name)
      end

  	  # Related startups based on tags
  	  def related
  	  	tags = self.tags
  	  	return if tags.nil? or self.id.nil?
  	  	return @related unless @related.nil?
  	  	results = []

  	  	tags.each do |tag|
  	  		_tags = Tag.where(:name => tag.name).where("`tags`.`listing` != ?", self.id).all
  	  		next if _tags.count

  	  		_tags.each do |_tag|
  	  			results.push(Listing.find(_tag.listing))
  	  		end
  	  	end

  	  	(@related = results) || nil
  	  end


  	  def json
        _tags = []
        self.tags.each do |tag|
          _tags.push(tag.json)
        end

  	  	{
  	  		:startup => {
  	  			:id => self.id,
  	  			:name => self.name,
  	  			:url => "http://www.builtinmcr.com/#{self.slug}",
  	  			:logo => self.logo,
  	  			:address => self.address.split(/\r?\n/).map{ |e| e[0..-2] },
  	  			:raw_address => self.address,
  	  			:description => self.description,
  	  			:employees => self.employees,
  	  			:twitter => "http://twitter.com/#{self.twitter[1..-1]}",
  	  			:founders => self.founders.to_s.include?(', ') ? self.founders.split(", ") : self.founders,
  	  			:hiring => {
  	  				:currently => self.hiring,
  	  				:url => self.hiringurl
  	  			},
  	  			:tags => _tags
  	  		},
  	  		:when => {
  	  			:listed => self.created_at,
  	  			:updated => self.updated_at
  	  		}
  	  	}
  	  end
end
