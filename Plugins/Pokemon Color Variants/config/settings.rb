#==============================================================================
# Settings
#==============================================================================
module PokemonColorVariants

  # The odds of a newly generated Pokémon having an hue color (out of 65536)
  HUE_POKEMON_CHANCE = 128 # default: 128 (1 chance over 512) (128/65536 = 1/512)
  
  # Sprite rules
  APPLY_TO_NORMAL      = true  # Apply hue shift to normal pokémons
  APPLY_TO_SHINY       = true  # Apply hue shift to shiny pokémons
  APPLY_TO_SUPER_SHINY = true  # Apply hue shift to super shiny pokémons
  APPLY_TO_EGG         = false # Apply the hue shift to the eggs
  APPLY_TO_ICON        = false # Apply the hue shift to the icons

  # Hue icon
  USE_HUE_ICON = true # Show the hue star icon
end
