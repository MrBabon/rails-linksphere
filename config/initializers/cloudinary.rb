require 'cloudinary'
Cloudinary.config_from_url(ENV['CLOUDINARY_URL']) if ENV['CLOUDINARY_URL']
