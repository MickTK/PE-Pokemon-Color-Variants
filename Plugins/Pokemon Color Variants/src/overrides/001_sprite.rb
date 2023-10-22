#==============================================================================
# Species
#==============================================================================
# Applies the hue shift on the front/back pokémon sprite
#------------------------------------------------------------------------------
module GameData
  class Species
    Species.singleton_class.alias_method :pokemon_color_variants_sprite_bitmap_from_pokemon, :sprite_bitmap_from_pokemon
    def self.sprite_bitmap_from_pokemon(pokemon, back = false, species = nil)
      ret = pokemon_color_variants_sprite_bitmap_from_pokemon(pokemon, back, species)
      # Apply the hue to the sprite
      ret.bitmap.hue = pokemon.hue if pokemon.applicable_hue?
      return ret
    end
  end
end

#==============================================================================
# Pokemon Icon Sprite
#==============================================================================
# Applies the hue shift on the party's icons
#------------------------------------------------------------------------------
class PokemonIconSprite < Sprite
  def pokemon=(value)
    @pokemon = value
    @animBitmap&.dispose
    @animBitmap = nil
    if !@pokemon
      self.bitmap = nil
      @current_frame = 0
      return
    end
    hue = @pokemon.applicable_hue? && PokemonColorVariants::APPLY_TO_ICON ? @pokemon.hue : 0
    @animBitmap = AnimatedBitmap.new(GameData::Species.icon_filename_from_pokemon(value), hue)
    self.bitmap = @animBitmap.bitmap
    self.src_rect.width  = @animBitmap.height
    self.src_rect.height = @animBitmap.height
    @frames_count = @animBitmap.width / @animBitmap.height
    @current_frame = 0 if @current_frame >= @frames_count
    changeOrigin
  end
end

#==============================================================================
# Pokemon Box Icon
#==============================================================================
# Applies the hue shift on the pc's icons
#------------------------------------------------------------------------------
class PokemonBoxIcon < IconSprite
  def refresh
    return if !@pokemon
    hue = @pokemon.applicable_hue? && PokemonColorVariants::APPLY_TO_ICON ? @pokemon.hue : 0
    self.setBitmap(GameData::Species.icon_filename_from_pokemon(@pokemon), hue)
    self.src_rect = Rect.new(0, 0, self.bitmap.height, self.bitmap.height)
  end
end

#==============================================================================
# Egg Generator
#==============================================================================
# Generate a variant colored egg
#------------------------------------------------------------------------------
class DayCare
  module EggGenerator
    EggGenerator.singleton_class.alias_method :pokemon_color_variants_set_shininess, :set_shininess
    def self.set_shininess(egg, mother, father)
      pokemon_color_variants_set_shininess(egg,mother,father)
      if PokemonColorVariants.check_odds() && egg.applicable_hue?
        egg.set_random_hue()
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
