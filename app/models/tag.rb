class Tag < ActiveRecord::Base
  attr_accessible :listing, :name

  # Check for duplicates
  before_save :is_duplicate
  def is_duplicate
  	t = Tag.where(:listing => self.listing, :name => self.name)

  	if t.count > 0 then
  		errors.add(:name, "already exists for this listing")
  		return false # stops creating it
  	end
  end

  public

    def json
      return {} if self.id.nil?

      {
        :id => self.id,
        :url => "http://builtinmcr.com/tag/#{self.name}",
        :name => self.name
      }
    end
end
