#==============================================================================
# [DBK] Animated Pokémon System
#==============================================================================
if PluginManager.installed?("[DBK] Animated Pokémon System")
  # Disable default super shiny hue
  module GameData
    class SpeciesMetrics
      def sprite_super_hue()
        return 0
      end
    end
  end
  # Change the pokemon hue color
  class DeluxeBitmapWrapper
    alias :pokemon_color_variants_setPokemon :setPokemon
    def setPokemon(pokemon, back = false, hue = nil, species = nil)
      pokemon_color_variants_setPokemon(pokemon, back, nil, species)
      return if !@pokemon
      pkmn = nil
      case @pokemon
      when Pokemon; pkmn = @pokemon
      when Battle::Battler; pkmn = @pokemon.visiblePokemon
      end
      return if !pkmn
      hue_change(pkmn.hue) if pkmn.hue? && pkmn.applicable_hue?
    end
  end
  # Hue editor changes
  module PokemonColorVariants
    class EditorScene
      alias :animated_pokemon_system_draw :draw
      def draw()
        animated_pokemon_system_draw()
        @sprites["front_sprite"].x = 130 - @sprites["front_sprite"].bitmap.height/2
        @sprites["front_sprite"].y = 160 - @sprites["front_sprite"].bitmap.height/2
        @sprites["front_sprite"].update()
        @sprites["back_sprite"].x = 380 - @sprites["back_sprite"].bitmap.height/2 + @sprites["back_sprite"].bitmap.height*0.25/2
        @sprites["back_sprite"].y = 160 - @sprites["back_sprite"].bitmap.height/2 + @sprites["back_sprite"].bitmap.height*0.25/2
        @sprites["back_sprite"].zoom_x = 0.75
        @sprites["back_sprite"].zoom_y = 0.75
        @sprites["back_sprite"].update()
      end
      alias :animated_pokemon_system_update_animations :update_animations
      def update_animations()
        animated_pokemon_system_update_animations()
        @sprites["front_sprite"].update()
        @sprites["back_sprite"].update()
      end
    end
  end
end
