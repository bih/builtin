class StartupsController < ApplicationController

  def index
  	@hi = self.hi # Custom Hi Messages
  	@listings = Listing.where(:active => true, :featured => true).random(12)
  end

  # Manually pick featured startups
  # def index
  # 	# Hand crafted <3
  # 	@ids = [2, 3]

  # 	@hi = self.hi
  # 	@listings = Listing.where(:active => true, :id => @ids).limit(12).all
  # end

  def hiring
  	@title = "Hiring Startups"
  	@listings = Listing.where(:active => true, :hiring => true).order("created_at ASC").all
  end

  def latest
  	@title = "Latest Startups"
  	@listings = Listing.where(:active => true).order("created_at ASC").limit(12).all
  end

  def all
  	@title = "All Startups"
  	@listings = Listing.where(:active => true).order("name ASC").all
  end

  def by_tag
  	@tag = params[:tag]
  	@title = "Startups Tagged: #{@tag}"
  	@listings = Listing.by_tag(@tag).all

  	render action: "tag"
  end

  def search
  	@listings = []
  	return if params[:q].nil?

  	# Ignore capitalisation
  	@listings = Listing.search(params[:q])
  	
  	respond_to do |format|
  		format.html {
		  	return if params[:q].to_s.length < 2
  		}
  		format.json {
  			return render json: { :count => 0 } if params[:q].nil?
  			return render json: { :count => 0 } if params[:q].to_s.length < 3

  			@output = { :count => @listings.count, :results => Array.new }

  			@listings.each do |listing|
  				@output[:results].push(listing.json)
  			end

  			render json: @output
  		}
  	end
  end

  # GET /apply
  def apply
  	@title = "Apply"
  	@listing = Listing.new
  end

  # POST /apply
  def create
    # File uploading
    file = params[:listing][:logo]

    # Instance
    @title = "Successful Application"
    @listing = Listing.new(params[:listing])

    if file.nil? then
      @listing.errors.add(:logo, "was not uploaded. Try again")
      render "startups/apply"
      return
    end

    f = FastImage.size(file.path)

    unless f[0] == 520 and f[1] == 280 then
    	@listing.errors.add(:logo, "must be 520x280")
    	render "startups/apply"
    	return
    end

    # Amazon S3
    filename = sanitize_filename(@listing.name).downcase + File.extname(file.original_filename)
    AWS::S3::S3Object.store(filename, file.read, 'builtinmcr-assets', :access => :public_read)    
    @listing.logo = AWS::S3::S3Object.url_for(filename, 'builtinmcr-assets', :authenticated => false)

    # Must not be active
    @listing.active = false
    @listing.featured = false

    if @listing.save
      render "startups/successful_application"
    else
      render "startups/apply"
    end
  end

  # Show Startup
  def show
  	@listing = Listing.where(:active => true, :slug => params[:slug]).first
  	@title = @listing.name

    respond_to do |format|
      format.html
      #format.json { render json: @listing.json }
      #format.jsonp { render json: JSON.pretty_generate(@listing.json) }
    end
  end

end
