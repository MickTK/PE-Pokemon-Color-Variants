#==============================================================================
# Visible Overworld Wild Encounters
#==============================================================================
if PluginManager.installed?("Visible Overworld Wild Encounters") && PokemonColorVariants::APPLY_TO_OVERWORLD_WILD_ENCOUNTERS
  class Game_Map
    def spawnPokeEvent(x,y,pokemon)
      event = RPG::Event.new(x,y)
      key_id = (@events.keys.max || -1) + 1
      event.id = key_id
      event.x = x
      event.y = y
      encounter = [pokemon.species,pokemon.level]
      form = pokemon.form
      gender = pokemon.gender
      shiny = pokemon.shiny?
      graphic_form = (VisibleEncounterSettings::SPRITES[0] && form!=nil) ? form : 0
      graphic_gender = (VisibleEncounterSettings::SPRITES[1] && gender!=nil) ? gender : 0
      graphic_shiny = (VisibleEncounterSettings::SPRITES[2] && shiny!=nil) ? shiny : false
      fname = ow_sprite_filename(x, y, encounter[0].to_s, graphic_form, graphic_gender, graphic_shiny)
      fname.gsub!("Graphics/Characters/","")
      event.pages[0].graphic.character_name = fname
      event.pages[0].graphic.character_hue = pokemon.hue if pokemon.hue? && pokemon.applicable_hue? # Pokemon Color Variant injection
      event.pages[0].move_speed = VisibleEncounterSettings::DEFAULT_MOVEMENT[0]
      event.pages[0].move_frequency = VisibleEncounterSettings::DEFAULT_MOVEMENT[1]
      event.pages[0].move_type = VisibleEncounterSettings::DEFAULT_MOVEMENT[2]
      event.pages[0].step_anime = true if VisibleEncounterSettings::USE_STEP_ANIMATION
      event.pages[0].trigger = 2
      event.pages[0].move_route.list[0].code = 10
      event.pages[0].move_route.list[1] = RPG::MoveCommand.new
      for move in VisibleEncounterSettings::Enc_Movements do
        if pokemon.method(move[0]).call == move[1]
          event.pages[0].move_speed = move[2] if move[2]
          event.pages[0].move_frequency = move[3] if move[3]
          event.pages[0].move_type = move[4] if move[4]
        end
      end
      Compiler::push_script(event.pages[0].list,sprintf(" pbStoreTempForBattle()"))
      if $PokemonGlobal.roamEncounter!=nil
        parameter1 = $PokemonGlobal.roamEncounter[0].to_s
        parameter2 = $PokemonGlobal.roamEncounter[1].to_s
        parameter3 = $PokemonGlobal.roamEncounter[2].to_s
        $PokemonGlobal.roamEncounter[3] != nil ? (parameter4 = '"'+$PokemonGlobal.roamEncounter[3].to_s+'"') : (parameter4 = "nil")
        parameter = " $PokemonGlobal.roamEncounter = ["+parameter1+",:"+parameter2+","+parameter3+","+parameter4+"] "
      else
        parameter = " $PokemonGlobal.roamEncounter = nil "
      end
      Compiler::push_script(event.pages[0].list,sprintf(parameter))
      parameter = ($game_temp.roamer_index_for_encounter!=nil) ? " $game_temp.roamer_index_for_encounter = "+$game_temp.roamer_index_for_encounter.to_s : " $game_temp.roamer_index_for_encounter = nil "
      Compiler::push_script(event.pages[0].list,sprintf(parameter))
      parameter = ($PokemonGlobal.nextBattleBGM!=nil) ? " $PokemonGlobal.nextBattleBGM = '"+$PokemonGlobal.nextBattleBGM.to_s+"'" : " $PokemonGlobal.nextBattleBGM = nil "
      Compiler::push_script(event.pages[0].list,sprintf(parameter))
      parameter = ($game_temp.force_single_battle!=nil) ? " $game_temp.force_single_battle = "+$game_temp.force_single_battle.to_s : " $game_temp.force_single_battle = nil "
      Compiler::push_script(event.pages[0].list,sprintf(parameter))
      parameter = ($game_temp.encounter_type!=nil) ? " $game_temp.encounter_type = :"+$game_temp.encounter_type.to_s : " $game_temp.encounter_type = nil "
      Compiler::push_script(event.pages[0].list,sprintf(parameter))
      Compiler::push_branch(event.pages[0].list,sprintf(" pbCheckBattleAllowed()"))
      Compiler::push_script(event.pages[0].list,sprintf(" $PokemonGlobal.battlingSpawnedPokemon = true"),1)    
      if !$map_factory
        parameter = " pbSingleOrDoubleWildBattle( $game_map.events[#{key_id}].map.map_id, $game_map.events[#{key_id}].x, $game_map.events[#{key_id}].y, $game_map.events[#{key_id}].pokemon )"
      else
        mapId = $game_map.map_id
        parameter = " pbSingleOrDoubleWildBattle( $map_factory.getMap("+mapId.to_s+").events[#{key_id}].map.map_id, $map_factory.getMap("+mapId.to_s+").events[#{key_id}].x, $map_factory.getMap("+mapId.to_s+").events[#{key_id}].y, $map_factory.getMap("+mapId.to_s+").events[#{key_id}].pokemon )"
      end
      Compiler::push_script(event.pages[0].list,sprintf(parameter),1)
      Compiler::push_script(event.pages[0].list,sprintf(" $PokemonGlobal.battlingSpawnedPokemon = false"),1) 
      Compiler::push_script(event.pages[0].list,sprintf(" pbResetTempAfterBattle()"),1)
      if !$map_factory
        parameter = "$game_map.removeThisEventfromMap(#{key_id})"
      else
        mapId = $game_map.map_id
        parameter = "$map_factory.getMap("+mapId.to_s+").removeThisEventfromMap(#{key_id})"
      end
      Compiler::push_script(event.pages[0].list,sprintf(parameter),1)
      Compiler::push_branch_end(event.pages[0].list,1)
      Compiler::push_script(event.pages[0].list,sprintf(" pbResetTempAfterBattle()"))
      Compiler::push_end(event.pages[0].list)
      gameEvent = Game_PokeEvent.new(@map_id, event, self)
      gameEvent.id = key_id
      gameEvent.moveto(x,y)
      gameEvent.pokemon = pokemon
      for step in VisibleEncounterSettings::Add_Steps_Before_Vanish
        step_method = step[0]
        step_value = step[1]
        step_count = step[2]
        if pokemon.method(step_method).call == step_value
          gameEvent.remaining_steps += step_count
        end
      end
      @events[key_id] = gameEvent
      sprite = Sprite_Character.new(Spriteset_Map.viewport,@events[key_id])
      $scene.spritesets[self.map_id]=Spriteset_Map.new(self) if $scene.spritesets[self.map_id]==nil
      $scene.spritesets[self.map_id].character_sprites.push(sprite)
    end
  end
end
