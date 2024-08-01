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

	def palette_change(old_palette, new_palette)
		return if old_palette == "" || old_palette == nil || new_palette == "" || new_palette == nil
		validate old_palette => String
		validate new_palette => String
		pixel = nil
		_old = old_palette.tr("\t","").tr(" ","").split("\n")
		_new = new_palette.tr("\t","").tr(" ","").split("\n")
		_dict = {}
		for i in 0..(_old.length-1)
			_dict[_old[i]] = _new[i]
		end
		for x in 0..(self.width-1)
			for y in 0..(self.height-1)
				pixel = self.get_pixel(x,y).to_hex()
				self.set_pixel(x,y,Color.from_hex(_dict[pixel])) if _dict.key?(pixel) && self.get_pixel(x,y).alpha > 0
			end
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
		if !shiny? && !super_shiny? && PokemonColorVariants::APPLY_TO_NORMAL
			return true if !egg? || (egg? && PokemonColorVariants::APPLY_TO_EGG)
		elsif shiny? && PokemonColorVariants::APPLY_TO_SHINY
			return true if !egg? || (egg? && PokemonColorVariants::APPLY_TO_EGG)
		elsif super_shiny? && PokemonColorVariants::APPLY_TO_SUPER_SHINY
			return true if !egg? || (egg? && PokemonColorVariants::APPLY_TO_EGG)
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
		return applicable_hue?
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
