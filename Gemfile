source 'https://rubygems.org'

# The usual
gem 'rails', '3.2.12'

# Database
gem 'mysql2'

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

group :development, :testing, :production do
	gem 'haml-rails'
	gem 'open-meta-tags', :require => 'open_meta_tags'

	# S3 Uploads
	gem 'aws-s3', '0.6.2', :require => 'aws/s3'

	# Image Detection
	gem 'fastimage'

	# ActiveRecord .rand() support
	gem 'randumb'

	# Data migrations
	gem 'yaml_db'
end

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'
