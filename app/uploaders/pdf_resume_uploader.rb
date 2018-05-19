class PdfResumeUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  storage :upyun

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
 
  def extension_whitelist
    %w(pdf)
  end
end
