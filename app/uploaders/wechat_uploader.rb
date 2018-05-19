class WechatUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  storage :upyun

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
 
  version :middle do
    resize_to_limit(600, 600)
  end

  def extension_whitelist
    %w(jpg jpeg gif png)
  end
end
