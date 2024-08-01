#==============================================================================
# Settings
#==============================================================================
module PokemonColorVariants

	# The odds of a newly generated Pokémon having an hue color (out of 65536)
	HUE_POKEMON_CHANCE = 128 # default: 128 (1 chance over 512) (128/65536 = 1/512)
	
	# Sprite rules
	APPLY_TO_NORMAL      = true  # Apply hue shift to normal pokémons (default: true)
	APPLY_TO_SHINY       = true  # Apply hue shift to shiny pokémons (default: true)
	APPLY_TO_SUPER_SHINY = true  # Apply hue shift to super shiny pokémons (default: true)
	APPLY_TO_EGG         = false # Apply the hue shift to the eggs (default: false)
	APPLY_TO_ICON        = false # Apply the hue shift to the icons (default: false)

	# Hue icon
	USE_HUE_ICON = true # Show the hue star icon (default: true)

	# Egg palette
	PASS_PALETTE_DOWN = true # Parents pass down the palette to the newborn (default: true)
end
