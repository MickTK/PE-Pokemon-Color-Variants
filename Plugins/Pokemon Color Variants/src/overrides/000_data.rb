#==============================================================================
# Bitmap
#==============================================================================
# Adds a new attribute (hue) 
#------------------------------------------------------------------------------
class Bitmap

  attr_reader :hue
  
  def hue=(hue)
    @hue = 0 if @hue == nil
    diff = hue - @hue
    self.hue_change(diff)
    @hue += diff
  end
end

#==============================================================================
# Pokemon
#==============================================================================
# Adds a new attribute (hue) 
#------------------------------------------------------------------------------
class Pokemon

  DEFAULT_HUE_VALUE = 0

  # Get the hue
  def hue()
    return hue? ? @hue : DEFAULT_HUE_VALUE
  end

  # Set the hue
  def hue=(value)
    @hue = value.to_i % PokemonColorVariants::MAX_ANGLE
  end

  # Check if the pokémon has an hue
  def hue?
    return !(@hue == nil || @hue == DEFAULT_HUE_VALUE)
  end

  # Set a random hue to the pokémon
  def set_random_hue()
    if !PokemonColorVariants::SPECIFIC_HUE_ENABLED
      self.hue = 1 + rand(PokemonColorVariants::MAX_ANGLE - 2)
    elsif PokemonColorVariants::POKEMON_HUE.include?(self.species)
      hue = PokemonColorVariants::POKEMON_HUE[self.species]
      self.hue = hue[rand(hue.length-1)]
    end
  end

  # Check if the hue is applicable to the pokémon
  def applicable_hue?
    if !shiny? && !super_shiny? && PokemonColorVariants::APPLY_TO_NORMAL
      return true if !egg? || (egg? && PokemonColorVariants::APPLY_TO_EGG)
    elsif shiny? && PokemonColorVariants::APPLY_TO_SHINY
      return true if !egg? || (egg? && PokemonColorVariants::APPLY_TO_EGG)
    elsif super_shiny? && PokemonColorVariants::APPLY_TO_SUPER_SHINY
      return true if !egg? || (egg? && PokemonColorVariants::APPLY_TO_EGG)
    end
    return false
  end
end

#==============================================================================
# Trainer
#==============================================================================
# Read the hue value in the trainers PBS file
#------------------------------------------------------------------------------
module GameData
  class Trainer

    SUB_SCHEMA["Hue"] = [:hue, "u"] # PBS parameter

    alias :pokemon_color_variants_to_trainer :to_trainer
    def to_trainer
      trainer = pokemon_color_variants_to_trainer
      for i in 0..(trainer.party.length-1)
        # Set the hue color to the trainer's pokémon
        trainer.party[i].hue = @pokemon[i][:hue]
      end
      return trainer
    end
  end
end
