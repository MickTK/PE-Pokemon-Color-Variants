#==============================================================================
# Pokemon Data Box
#==============================================================================
# Draws the hue icon in the battle scene
#------------------------------------------------------------------------------
if PokemonColorVariants::USE_HUE_ICON
  class Battle::Scene::PokemonDataBox < Sprite
    alias pokemon_color_variants_draw_shiny_icon draw_shiny_icon
    def draw_shiny_icon
      shiny_x = (@battler.opposes?(0)) ? 206 : -6   # Foe's/player's
      if @battler.pokemon.hue? && @battler.pokemon.applicable_hue?
        pbDrawImagePositions(self.bitmap, [[PokemonColorVariants::HUE_ICON, @spriteBaseX + shiny_x, 36]])
      end
      pokemon_color_variants_draw_shiny_icon() # Draws the default images above
    end
  end
end

#==============================================================================
# Pokemon Party Panel
#==============================================================================
# Draws the hue icon in the party menu
#------------------------------------------------------------------------------
if PokemonColorVariants::USE_HUE_ICON
  class PokemonPartyPanel < Sprite
    alias pokemon_color_variants_draw_shiny_icon draw_shiny_icon
    def draw_shiny_icon
      if @pokemon.hue? && @pokemon.applicable_hue?
        pbDrawImagePositions(@overlaysprite.bitmap, [[PokemonColorVariants::HUE_ICON,80,48,0,0,16,16]])
      end
      pokemon_color_variants_draw_shiny_icon() # Draws the default images above
    end
  end
end

#==============================================================================
# Pokemon Summary Scene
#==============================================================================
# Draws the hue icon in the summary scene
#------------------------------------------------------------------------------
if PokemonColorVariants::USE_HUE_ICON
  class PokemonSummary_Scene
    alias pokemon_color_variants_drawPage drawPage
    def drawPage(page)
      pokemon_color_variants_drawPage(page)
      overlay = @sprites["overlay"].bitmap
      if @pokemon.hue? && @pokemon.applicable_hue?
        pbDrawImagePositions(overlay, [[PokemonColorVariants::HUE_ICON,2,134]])
      end
      # Redraws the shiny star above
      if @pokemon.shiny? && !@pokemon.egg?
        pbDrawImagePositions(overlay,[["Graphics/UI/shiny",2,134]])
      end
    end
  end
end

#==============================================================================
# Pokemon Storage Scene
#==============================================================================
# Draws the hue icon in the storage scene
#------------------------------------------------------------------------------
if PokemonColorVariants::USE_HUE_ICON
  class PokemonStorageScene
    alias pokemon_color_variants_pbUpdateOverlay pbUpdateOverlay
    def pbUpdateOverlay(selection, party = nil)
      pokemon_color_variants_pbUpdateOverlay(selection, party)
      pokemon = nil
      if @screen.pbHeldPokemon
        pokemon = @screen.pbHeldPokemon
      elsif selection >= 0
        pokemon = (party) ? party[selection] : @storage[@storage.currentBox, selection]
      end
      return if !pokemon
      overlay = @sprites["overlay"].bitmap
      if pokemon.hue? && pokemon.applicable_hue?
        pbDrawImagePositions(overlay, [[PokemonColorVariants::HUE_ICON,156,198]])
      end
      # Redraws the shiny star above
      if pokemon.shiny? && !pokemon.egg?
        pbDrawImagePositions(overlay,[["Graphics/UI/shiny", 156, 198]])
      end
    end
  end
end
