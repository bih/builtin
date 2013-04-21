class AdminController < ApplicationController
  before_filter :authenticate

  @@username = "builtinmcr"
  @@password = "bilaw.al"

  # GET /listings
  # GET /listings.json
  def index
    @listings = Listing.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @listings }
    end
  end

  # GET /listings/1/edit
  def edit
    @listing = Listing.find(params[:id])
    @tags = @listing.comma_tags
  end

  # PUT /listings/1
  # PUT /listings/1.json
  def update
    @listing = Listing.find(params[:id])

    unless params[:comma_tags].nil? then
    	@listing.update_comma_tags(params[:comma_tags])
    end

    unless params[:listing][:logo].nil? then
    	file = params[:listing][:logo]
	    f = FastImage.size(file.path)

	    unless f[0] == 520 and f[1] == 280 then
	    	@listing.errors.add(:logo, "must be 520x280")
	    	render "startups/apply"
	    	return
	    end

	    # Amazon S3
	    filename = sanitize_filename(@listing.name).downcase + File.extname(file.original_filename)
	    
	    AWS::S3::S3Object.delete(File.basename(@listing.logo), 'builtinmcr-assets')
	    AWS::S3::S3Object.delete(filename, 'builtinmcr-assets')
	    
	    AWS::S3::S3Object.store(filename, file.read, 'builtinmcr-assets', :access => :public_read)

	    params[:listing][:logo] = AWS::S3::S3Object.url_for(filename, 'builtinmcr-assets', :authenticated => false)
	end

    if @listing.update_attributes(params[:listing])
    	redirect_to admin_index_path
    else
        render action: "edit"
    end
  end

  # DELETE /listings/1
  # DELETE /listings/1.json
  def destroy
    @listing = Listing.find(params[:id])
    @listing.destroy

    redirect_to admin_index_path
  end

  protected

  def authenticate
	return if session[:admin].to_s.eql?(@@username + "-" + @@password)
    
    authenticate_or_request_with_http_basic do |username, password|
      if username == @@username && password == @@password then
      	session[:admin] = @@username + "-" + @@password
      end
    end
  end

end
