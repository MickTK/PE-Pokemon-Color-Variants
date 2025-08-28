#==============================================================================
# Following Pokemon EX
#==============================================================================
if PluginManager.installed?("Following Pokemon EX") && PokemonColorVariants::APPLY_TO_FOLLOWING_POKEMON
  module FollowingPkmn
    FollowingPkmn.singleton_class.alias_method :pokemon_color_variants_change_sprite, :change_sprite
    def self.change_sprite(pkmn)
      pokemon_color_variants_change_sprite(pkmn)
      if pkmn.hue? && pkmn.applicable_hue?
        FollowingPkmn.get_event().character_hue = pkmn.hue
        FollowingPkmn.get_data().character_hue = pkmn.hue
      end
    end
  end
end
