class PictureUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick 

  storage :fog                   

  process :convert => 'png'

  version :thumb do
    resize_to_fill 100, 100
  end

  def store_dir
    "#{model.resource_type.to_s.underscore}/#{model.type}"
  end

  def filename
    if original_filename.present?
      name = super.chomp(File.extname(super))
      "#{name}_#{secure_token(10)}.#{file.extension}"
    end
  end

 protected
 def secure_token(length=16)
   var = :"@#{mounted_as}_secure_token"
   model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.hex(length/2))
 end
end