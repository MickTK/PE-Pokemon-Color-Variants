#==============================================================================
# Pokemon Color Variants
#==============================================================================
module PokemonColorVariants

  # Macros
  SHINY_CAP = 65536
  MAX_ANGLE = 360

  # Graphics
  HUE_ICON          = "Graphics/Plugins/Pokemon Color Variants/UI/hue_icon.png"
  EDITOR_BACKGROUND = "Graphics/Plugins/Pokemon Color Variants/Editor/editor_background.png"
  EDITOR_THUMB      = "Graphics/Plugins/Pokemon Color Variants/Editor/editor_thumb.png"

  # Checks the odds
  def self.check_odds()
    return HUE_POKEMON_CHANCE > rand(SHINY_CAP-1)
  end
end
