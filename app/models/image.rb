class Image < ActiveRecord::Base
  belongs_to :species

  # Add a paperclip interpolation for species name
  Paperclip.interpolates :species_name do |attachment, style|
    attachment.instance.species.genusSpecies
  end

  has_attached_file :image,
                    :styles => { :medium => "300x300>",
                    :thumb => "100x100>" }, :default_url => "/images/:style/missing.png",
                    :path => ":rails_root/app/assets/images/species_images/:species_name/:id/:style_:basename.:extension",
                    :url  => "/assets/species_images/:species_name/:id/:style_:basename.:extension"

  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

  def image_url
    self.image.url(:original)
  end
end