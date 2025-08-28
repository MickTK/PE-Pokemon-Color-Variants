#==============================================================================
# Color
#==============================================================================
class Color
	def self.from_hex(hex, opacity=1)
		rgb = hex.match(/^#(..)(..)(..)$/).captures.map(&:hex)
		return Color.new(rgb[0], rgb[1], rgb[2], 255*opacity.clamp(0,1))
	end
	def to_hex()
		return sprintf("#%02x%02x%02x", red, green, blue)
	end
	# Convert a hex color to a RGBA
	def self.hex_to_rgba(hex)
		s = hex.strip.sub(/^#/,'')
		return [
			s[0,2].to_i(16),
			s[2,2].to_i(16),
			s[4,2].to_i(16),
			(s.length == 8) ? s[6,2].to_i(16) : 255
		] if [6,8].include?(s.length)
		return [0,0,0,0]
	end
end

#==============================================================================
# Bitmap
#==============================================================================
class Bitmap
	attr_reader :hue
	def hue=(hue)
		@hue = 0 if @hue == nil
		diff = hue - @hue
		self.hue_change(diff)
		@hue += diff
	end
	def palette_change(old_palette, new_palette, ignore_alpha=true)
		validate old_palette => String
		validate new_palette => String
		before = old_palette.scan(/#?[0-9a-fA-F]{6}(?:[0-9a-fA-F]{2})?/)
		after = new_palette.scan(/#?[0-9a-fA-F]{6}(?:[0-9a-fA-F]{2})?/)
		# Map the colors
		map = {}
		for i in 0...([before.size(), after.size()].min())
			og_color = Color.hex_to_rgba(before[i])
			new_color = Color.hex_to_rgba(after[i])
			if ignore_alpha
				og_color.pop()
				new_color.pop()
			end
			map[og_color] = new_color
		end
		data = self.raw_data.dup.force_encoding(Encoding::ASCII_8BIT)
		# Iterate for every pixel
		for i in 0...(data.bytesize/4)
			idx = i * 4
			r = data.getbyte(idx)
			g = data.getbyte(idx+1)
			b = data.getbyte(idx+2)
			a = data.getbyte(idx+3)
			current_pixel = ignore_alpha ? [r,g,b] : [r,g,b,a]
			new_pixel = map[current_pixel]
			next if !new_pixel
			data.setbyte(idx, new_pixel[0])   # R
			data.setbyte(idx+1, new_pixel[1]) # G
			data.setbyte(idx+2, new_pixel[2]) # B
			data.setbyte(idx+3, new_pixel[3]) if !ignore_alpha # A
		end
		self.raw_data = data
	end
end

#==============================================================================
# Cache
#==============================================================================
module RPG
  module Cache
    def self.removeKey(key)
      @cache.delete(key)
    end
  end
end

#==============================================================================
# Pokemon
#==============================================================================
class Pokemon

	DEFAULT_HUE_VALUE = 0
	DEFAULT_PALETTE_VALUE = ""

	#==========================
	# Hue
	#==========================
	# Get the hue
	def hue()
		return hue? ? @hue : DEFAULT_HUE_VALUE
	end
	# Set the hue
	def hue=(value)
		@hue = value.to_i % PokemonColorVariants::MAX_ANGLE
	end
	# Check if the pokémon has an hue
	def hue?
		return !(@hue == nil || @hue == DEFAULT_HUE_VALUE)
	end
	# Set a random hue to the pokémon
	def set_random_hue()
		if !PokemonColorVariants::SPECIFIC_HUE_ENABLED
			self.hue = 1 + rand(PokemonColorVariants::MAX_ANGLE - 2)
		elsif PokemonColorVariants::POKEMON_HUE.include?(self.species)
			hue = PokemonColorVariants::POKEMON_HUE[self.species]
			self.hue = hue[rand(hue.length-1)]
		end
	end
	# Check if the hue is applicable to the pokémon
	def applicable_hue?
		if (!shiny? && !super_shiny? && PokemonColorVariants::APPLY_TO_NORMAL) \
		|| (shiny? && PokemonColorVariants::APPLY_TO_SHINY) \
		|| (super_shiny? && PokemonColorVariants::APPLY_TO_SUPER_SHINY)
			return true if !egg? || PokemonColorVariants::APPLY_TO_EGG
		end
		return false
	end

	#==========================
	# Palette
	#==========================
	# Get the original palette
	def palette_0()
		return palette? ? @palette_0 : DEFAULT_PALETTE_VALUE
	end
	# Get the new palette
	def palette_1()
		return palette? ? @palette_1 : DEFAULT_PALETTE_VALUE
	end
	# Set the original palette
	def palette_0=(value)
		validate value => String
		@palette_0 = value
	end
	# Set the new palette
	def palette_1=(value)
		validate value => String
		@palette_1 = value
	end
	# Check if the pokémon has a new palette
	def palette?
		return @palette_0 != nil && @palette_1 != nil && @palette_0 != DEFAULT_PALETTE_VALUE && @palette_1 != DEFAULT_PALETTE_VALUE
	end
	# Check if the palette is applicable to the pokémon
	def applicable_palette?
		return PokemonColorVariants::ENABLED_PALETTES && applicable_hue?
	end
end

#==============================================================================
# Trainer
#==============================================================================
module GameData
	class Trainer

		# PBS parameters
		SUB_SCHEMA["Hue"] = [:hue, "u"]
		SUB_SCHEMA["Palette_0"] = [:palette_0, "s"]
		SUB_SCHEMA["Palette_1"] = [:palette_1, "s"]

		alias :pokemon_color_variants_to_trainer :to_trainer
		def to_trainer
			trainer = pokemon_color_variants_to_trainer
			for i in 0..(trainer.party.length-1)
				# Apply the color variation
				trainer.party[i].palette_0 = "#" + @pokemon[i][:palette_0].gsub(" ","\n#") if @pokemon[i][:palette_0]
				trainer.party[i].palette_1 = "#" + @pokemon[i][:palette_1].gsub(" ","\n#") if @pokemon[i][:palette_1]
				trainer.party[i].hue = @pokemon[i][:hue]
			end
			return trainer
		end
	end
end

#==============================================================================
# Egg Generator
#==============================================================================
# Generate a colored egg
#------------------------------------------------------------------------------
class DayCare
	module EggGenerator
		EggGenerator.singleton_class.alias_method :pokemon_color_variants_set_shininess, :set_shininess
		def self.set_shininess(egg, mother, father)
			pokemon_color_variants_set_shininess(egg,mother,father)
			if PokemonColorVariants.check_odds() && egg.applicable_hue?
				egg.set_random_hue()
			end
			if PokemonColorVariants::PASS_PALETTE_DOWN
				if GameData::Species.get(father.species).get_baby_species() == egg.species && father.palette?
					egg.palette_0 = father.palette_0
					egg.palette_1 = father.palette_1
				elsif GameData::Species.get(mother.species).get_baby_species() == egg.species && mother.palette?
					egg.palette_0 = mother.palette_0
					egg.palette_1 = mother.palette_1
				end
			end
		end
	end
end
