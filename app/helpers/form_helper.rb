module FormHelper
  def setup_species(species)
    species.species_locations ||= Species_locations.new
    species
  end
end
