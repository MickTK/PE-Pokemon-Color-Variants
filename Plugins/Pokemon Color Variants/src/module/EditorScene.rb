#==============================================================================
# Editor Scene
#==============================================================================
module PokemonColorVariants
  class EditorScene

    # Bitmap offset
    BITMAP_OFFSET = PictureOrigin::TOP_LEFT

    # Slider thumb
    STARTING_THUMB_X = 31 # Initial position of the thumb of the slider
    SMALL_STEP = 1  # Increment/decrement amount per input (left and right)
    BIG_STEP   = 10 # Increment/decrement amount per input (up and down)

    # Attributes
    attr_reader :pokemon          # The current pokémon shown in the editor
    attr_reader :original_pokemon # Reference to the initial pokémon
    attr_reader :can_be_saved     # If the hue can be saved after the edit
    attr_reader :viewport         # Viewport
    attr_reader :sprites          # Sprites

    def initialize(pokemon, can_be_saved = true)
      @original_pokemon = pokemon
      @pokemon          = pokemon.clone()
      @can_be_saved     = can_be_saved
      @viewport         = Viewport.new(0, 0, Graphics.width, Graphics.height)
      @viewport.z       = 99999
      @sprites          = {}
    end

    # Draw the scene
    def draw()
      # Background
      @sprites["background"] = Sprite.new(@viewport)
      @sprites["background"].bitmap = Bitmap.new(PokemonColorVariants::EDITOR_BACKGROUND)
      @sprites["background"].bitmap.hue = rand(PokemonColorVariants::MAX_ANGLE - 1)
      # Front sprite
      @sprites["front_sprite"] = PokemonSprite.new(@viewport)
      @sprites["front_sprite"].setPokemonBitmap(@pokemon)
      @sprites["front_sprite"].setOffset(BITMAP_OFFSET)
      @sprites["front_sprite"].x = 50
      @sprites["front_sprite"].y = 102
      # Back sprite
      @sprites["back_sprite"] = PokemonSprite.new(@viewport)
      @sprites["back_sprite"].setPokemonBitmap(@pokemon,true)
      @sprites["back_sprite"].setOffset(BITMAP_OFFSET)
      @sprites["back_sprite"].x = 302
      @sprites["back_sprite"].y = 102
      # Slider thumb
      @sprites["thumb"] = Sprite.new(@viewport)
      @sprites["thumb"].bitmap = Bitmap.new(PokemonColorVariants::EDITOR_THUMB)
      @sprites["thumb"].x = STARTING_THUMB_X + @pokemon.hue
      @sprites["thumb"].y = 319
      # Left icon
      @sprites["left_poke_icon"] = PokemonIconSprite.new(@pokemon, @viewport)
      @sprites["left_poke_icon"].setOffset(BITMAP_OFFSET)
      @sprites["left_poke_icon"].x = 128
      @sprites["left_poke_icon"].y = -15
      # Right icon
      @sprites["right_poke_icon"] = PokemonIconSprite.new(@pokemon, @viewport)
      @sprites["right_poke_icon"].setOffset(BITMAP_OFFSET)
      @sprites["right_poke_icon"].x = 320
      @sprites["right_poke_icon"].y = -15
      @sprites["right_poke_icon"].mirror = true
      # Hue value
      @sprites["hue_value"] = Sprite.new(@viewport)
      @sprites["hue_value"].bitmap = Bitmap.new(75,34)
      @sprites["hue_value"].x = 433
      @sprites["hue_value"].y = 317
      value = sprintf("%d", @pokemon.hue)
      drawTextEx(@sprites["hue_value"].bitmap,0,0,75,1,value,Color.new(255,255,255),Color.new(0,0,0,0))
    end

    # Update the scene
    def update()
      # Slider thumb
      @sprites["thumb"].x = STARTING_THUMB_X + @pokemon.hue
      # Front sprite
      @sprites["front_sprite"].bitmap.dispose()
      @sprites["front_sprite"].setPokemonBitmap(@pokemon)
      # Back sprite
      @sprites["back_sprite"].bitmap.dispose()
      @sprites["back_sprite"].setPokemonBitmap(@pokemon,true)
      # Left icon
      @sprites["left_poke_icon"].dispose()
      @sprites["left_poke_icon"] = PokemonIconSprite.new(@pokemon, @viewport)
      @sprites["left_poke_icon"].setOffset(BITMAP_OFFSET)
      @sprites["left_poke_icon"].x = 128
      @sprites["left_poke_icon"].y = -15
      # Right icon
      @sprites["right_poke_icon"].dispose()
      @sprites["right_poke_icon"] = PokemonIconSprite.new(@pokemon, @viewport)
      @sprites["right_poke_icon"].setOffset(BITMAP_OFFSET)
      @sprites["right_poke_icon"].x = 320
      @sprites["right_poke_icon"].y = -15
      @sprites["right_poke_icon"].mirror = true
      # Hue value
      @sprites["hue_value"].bitmap.clear
      value = sprintf("%d", @pokemon.hue)
      drawTextEx(@sprites["hue_value"].bitmap,0,0,75,1,value,Color.new(255,255,255),Color.new(0,0,0,0))
    end

    # Update the animation of the icons
    def update_animations()
      @sprites["left_poke_icon"].update
      @sprites["right_poke_icon"].update
    end

    # Control the scene
    def controller()
      loop do
        Graphics.update
        Input.update
        # Increase/decrese the hue value
        if    Input.repeat?(Input::RIGHT); @pokemon.hue += SMALL_STEP; update()
        elsif Input.repeat?(Input::LEFT);  @pokemon.hue -= SMALL_STEP; update()
        elsif Input.repeat?(Input::UP);    @pokemon.hue += BIG_STEP;   update()
        elsif Input.repeat?(Input::DOWN);  @pokemon.hue -= BIG_STEP;   update()
        # Save and quit
        elsif Input.trigger?(Input::USE)
          if @can_be_saved && pbConfirmMessage(_INTL("Do you want to save the hue?"))
            @original_pokemon.hue = @pokemon.hue
          end
          break
        elsif Input.trigger?(Input::BACK)
          break if !@can_be_saved || pbConfirmMessage(_INTL("Do you want to quit the editor?"))
        end
        # Update the icons animation
        update_animations()
      end
    end
    
    # Dispose the scene
    def dispose()
      pbDisposeSpriteHash(@sprites)
      @viewport.dispose()
    end
  end
end

# Show and use the hue editor scene with the given pokémon
def pbHueEditor(pokemon, can_be_saved = true)
  scene = PokemonColorVariants::EditorScene.new(pokemon, can_be_saved)
  pbFadeOutInWithMusic { scene.draw() }
  scene.controller()
  pbFadeOutInWithMusic {
    scene.dispose()
    yield if block_given?
  }
end
