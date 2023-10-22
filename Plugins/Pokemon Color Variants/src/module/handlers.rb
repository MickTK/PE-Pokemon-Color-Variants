#==============================================================================
# Event Handlers
#==============================================================================
# Set the hue value of the wild pokémons
#------------------------------------------------------------------------------
EventHandlers.add(:on_wild_pokemon_created,:pokemon_color_variants,
  proc { |pokemon|
    if PokemonColorVariants.check_odds() && pokemon.applicable_hue?
      pokemon.set_random_hue()
    end
  }
)

#==============================================================================
# Menu Handlers
#==============================================================================
# Debug menu
#------------------------------------------------------------------------------
MenuHandlers.add(:pokemon_debug_menu, :set_hue, {
  "name"   => _INTL("Set hue"),
  "parent" => :cosmetic,
  "effect" => proc { |pokemon, pokemon_id, h, s, screen|
    pbHueEditor(pokemon){
      screen.pbRefreshSingle(pokemon_id)
    }
    next false
  }
})
