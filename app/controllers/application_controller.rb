class ApplicationController < ActionController::Base
  protect_from_forgery

  	def sanitize_filename(filename)
	  returning filename.strip do |name|
	   # NOTE: File.basename doesn't work right with Windows paths on Unix
	   # get only the filename, not the whole path
	   name.gsub!(/^.*(\\|\/)/, '')

	   # Strip out the non-ascii character
	   name.gsub!(/[^0-9A-Za-z.\-]/, '_')
	  end
	end

	def hi
		hi = []
		hi.push( "Haai!" )
		hi.push( "Ola!" )
		hi.push( "Greetings!" )
		hi.push( "Hallo!" )
		hi.push( "Bonjour!" )
		hi.push( "How do you do?" )
		hi.push( "Namaste!" )
		hi.push( "Hola!" )
		hi.push( "Helo!" )
		hi.push( "Tja!" )

		hi.sample
	end
end
