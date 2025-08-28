#==============================================================================
# Species
#==============================================================================
# Applies the variation on the front/back pokémon sprite
#------------------------------------------------------------------------------
module GameData
	class Species
		Species.singleton_class.alias_method :pokemon_color_variants_sprite_bitmap_from_pokemon, :sprite_bitmap_from_pokemon
		def self.sprite_bitmap_from_pokemon(pokemon, back = false, species = nil)
			ret = pokemon_color_variants_sprite_bitmap_from_pokemon(pokemon, back, species)
			# Apply color variation
			ret.bitmap.palette_change(pokemon.palette_0, pokemon.palette_1) if pokemon.applicable_palette?
			ret.bitmap.hue = pokemon.hue if pokemon.applicable_hue?
			return ret
		end
	end
end

#==============================================================================
# Pokemon Icon Sprite
#==============================================================================
# Applies the variation on the party's icons
#------------------------------------------------------------------------------
if PokemonColorVariants::APPLY_TO_ICON
	class PokemonIconSprite < Sprite
		alias :pokemon_color_variants_pokemon= :pokemon=
		def pokemon=(value)
			# Remove the sprite from the cache
			RPG::Cache.removeKey(GameData::Species.icon_filename_from_pokemon(value))
			self.pokemon_color_variants_pokemon = value
			# Apply color variation
			self.bitmap.palette_change(@pokemon.palette_0, @pokemon.palette_1) if @pokemon.palette? && @pokemon.applicable_palette?
			self.bitmap.hue = @pokemon.hue if @pokemon.applicable_hue?
		end
	end
end

#==============================================================================
# Pokemon Box Icon
#==============================================================================
# Applies the variation on the pc's icons
#------------------------------------------------------------------------------
if PokemonColorVariants::APPLY_TO_ICON
	class PokemonBoxIcon < IconSprite
		alias :pokemon_color_variants_refresh :refresh
		def refresh
			return if !@pokemon
			# Remove the sprite from the cache
			RPG::Cache.removeKey(GameData::Species.icon_filename_from_pokemon(@pokemon))
			pokemon_color_variants_refresh()
			# Apply color variation
			self.bitmap.palette_change(@pokemon.palette_0, @pokemon.palette_1) if @pokemon.palette? && @pokemon.applicable_palette?
			self.bitmap.hue = @pokemon.hue if @pokemon.applicable_hue?
		end
	end
end

#==============================================================================
# Battle Scene
#==============================================================================
# Play the shiny animation if the pokémon has a hue
#------------------------------------------------------------------------------
if PokemonColorVariants::USE_SHINY_ANIMATION
  class Battle::Scene
		# Enemy/wild pokémon animation
    alias :pokemon_color_variants_pbBattleIntroAnimation :pbBattleIntroAnimation
    def pbBattleIntroAnimation()
      pokemon_color_variants_pbBattleIntroAnimation()
      if @battle.showAnims
        @battle.sideSizes[1].times do |i|
          idxBattler = (2 * i) + 1
          next if @battle.battlers[idxBattler].shiny? \
					|| !@battle.battlers[idxBattler].pokemon.hue? \
					|| !@battle.battlers[idxBattler].pokemon.applicable_hue?
          pbCommonAnimation("Shiny", @battle.battlers[idxBattler])
        end
      end
    end
		# Player pokémon animation
    alias :pokemon_color_variants_pbSendOutBattlers :pbSendOutBattlers
    def pbSendOutBattlers(sendOuts, startBattle = false)
      pokemon_color_variants_pbSendOutBattlers(sendOuts, startBattle)
      sendOuts.each do |b|
        next if !@battle.showAnims || @battle.battlers[b[0]].shiny? \
				|| !@battle.battlers[b[0]].pokemon.hue? \
				|| !@battle.battlers[b[0]].pokemon.applicable_hue?
        pbCommonAnimation("Shiny", @battle.battlers[b[0]])
      end
    end
  end
end

#==============================================================================
# Pokemon Egg Hatch Scene
#==============================================================================
# Shows the colored egg in the hatching scene
#------------------------------------------------------------------------------
class PokemonEggHatch_Scene
	def pbStartScene(pokemon)
		@sprites = {}
		@pokemon = pokemon
		@nicknamed = false
		@viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
		@viewport.z = 99999
		# Create background image
		addBackgroundOrColoredPlane(@sprites, "background", "hatch_bg",
																Color.new(248, 248, 248), @viewport)
		# Create egg sprite/Pokémon sprite
		@sprites["pokemon"] = PokemonSprite.new(@viewport)
		@sprites["pokemon"].setOffset(PictureOrigin::BOTTOM)
		@sprites["pokemon"].x = Graphics.width / 2
		@sprites["pokemon"].y = 264 + 56   # 56 to offset the egg sprite
		@sprites["pokemon"].setSpeciesBitmap(@pokemon.species, @pokemon.gender,
																				 @pokemon.form, @pokemon.shiny?,
																				 false, false, true)   # Egg sprite
		# Apply color variation
		@sprites["pokemon"].bitmap.palette_change(pokemon.palette_0, pokemon.palette_1) if pokemon.applicable_palette? # Palette
		@sprites["pokemon"].bitmap.hue = pokemon.hue if pokemon.applicable_hue? # Hue
		# Load egg cracks bitmap
		crackfilename = GameData::Species.egg_cracks_sprite_filename(@pokemon.species, @pokemon.form)
		@hatchSheet = AnimatedBitmap.new(crackfilename)
		# Create egg cracks sprite
		@sprites["hatch"] = Sprite.new(@viewport)
		@sprites["hatch"].x = @sprites["pokemon"].x
		@sprites["hatch"].y = @sprites["pokemon"].y
		@sprites["hatch"].ox = @sprites["pokemon"].ox
		@sprites["hatch"].oy = @sprites["pokemon"].oy
		@sprites["hatch"].bitmap = @hatchSheet.bitmap
		@sprites["hatch"].src_rect = Rect.new(0, 0, @hatchSheet.width / 5, @hatchSheet.height)
		@sprites["hatch"].visible = false
		# Create flash overlay
		@sprites["overlay"] = BitmapSprite.new(Graphics.width, Graphics.height, @viewport)
		@sprites["overlay"].z = 200
		@sprites["overlay"].bitmap = Bitmap.new(Graphics.width, Graphics.height)
		@sprites["overlay"].bitmap.fill_rect(0, 0, Graphics.width, Graphics.height, Color.white)
		@sprites["overlay"].opacity = 0
		# Start up scene
		pbFadeInAndShow(@sprites)
	end
end
