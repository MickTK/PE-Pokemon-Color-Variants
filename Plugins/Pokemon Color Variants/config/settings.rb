#==============================================================================
# Settings
#==============================================================================
module PokemonColorVariants

	#============================================================================
	# Wild encounter odds (between 0 and 65536)
	#============================================================================
	HUE_POKEMON_CHANCE = 128 # The odds of a newly generated Pokémon having an hue color (default: 128)
	
	#============================================================================
	# Sprite rules
	#============================================================================
	APPLY_TO_NORMAL      = true  # Apply hue shift to normal pokémons (default: true)
	APPLY_TO_SHINY       = true  # Apply hue shift to shiny pokémons (default: true)
	APPLY_TO_SUPER_SHINY = true  # Apply hue shift to super shiny pokémons (default: true)
	APPLY_TO_EGG         = false # Apply the hue shift to the eggs (default: false)
	APPLY_TO_ICON        = false # Apply the hue shift to the icons (default: false)

	#============================================================================
	# Hue icon
	#============================================================================
	USE_HUE_ICON = true # Show the hue star icon (default: true)

	#============================================================================
	# Animation effect
	#============================================================================
	USE_SHINY_ANIMATION = true # Play the shiny animation when starting a battle (default: true)

	#============================================================================
	# Palette (sperimental)
	#============================================================================
	ENABLED_PALETTES  = false # Enable the palette colors (default: false)
	PASS_PALETTE_DOWN = false # Parents pass down the palette to the newborn (default: false)

	#============================================================================
	# Integrations
	#============================================================================
	APPLY_TO_FOLLOWING_POKEMON         = true # Apply the hue shift to the following pokémon sprite (default: true)
	APPLY_TO_OVERWORLD_WILD_ENCOUNTERS = true # Apply the hue shift to the overworld wild encounters (default: true)
end
