![Essentials](https://badgen.net/badge/Essentials/21.1/orange)
![Version](https://badgen.net/badge/Version/1.3.0/cyan)

<p align="center">
<img width="200px" src="https://user-images.githubusercontent.com/63038410/277101961-6f414f38-9219-4b06-b1b0-0ccf45836f1e.png">
</p>

<h1 align="center">Pokémon Color Variants</h1>


<p align="center">
Forge your rainbow team!
</p>

<div align="center">
	<details>
	<summary>Community picks ❤️</summary>
		<img width="450px" src="https://user-images.githubusercontent.com/63038410/216767202-dded7695-8f3b-4c67-a419-f87122cbe246.png">
		<p>LilyInTheWater's Pidgey</p><br>
		<img width="450px" src="https://user-images.githubusercontent.com/63038410/216767426-8a821395-efdb-4a84-922c-0aa356864f7f.png">
		<p>MaouAlter's Eelektross</p><br>
		<img width="450px" src="https://user-images.githubusercontent.com/63038410/220905142-de4e0835-9ce7-4a1e-95b4-e2785c531416.png">
		<p>Citycat17's Solgaleo</p>
	</details>
</div>

## Overview

![showcase](https://user-images.githubusercontent.com/63038410/277104962-7e978829-7cd2-48f7-a697-6f43810545f7.gif)

- More than 700 variants for each pokémon
- Encount the pokémon variants in the wild or obtain them through breeding
- Bring more color to trainers team
- Create unique and wonderful variants to reward the player
- Customize the plugin to fit your needs

### Wild encounters and breeding

![encounter](https://user-images.githubusercontent.com/63038410/277105130-b1a9e2a3-4e88-4c8f-bd53-eeb09a4d6c71.gif)

![breeding](https://user-images.githubusercontent.com/63038410/277105137-d26fd2e4-7792-4e8e-a10a-fbfdfb14e362.gif)

Pokémon's variants can be found in the wild and from breeding with their own customizable odds.

### Trainer

![trainer](https://user-images.githubusercontent.com/63038410/277105181-5680dbd3-3a96-4407-8f15-b56ccbb7a834.gif)

The variants for the trainer's pokémons can be specified in the PBS file `trainers.txt` by adding the `Hue` tag as parameter.

For instance:

```
Pokemon = ONIX,10
  Gender = male
  Moves = HEADSMASH,ROCKTHROW,RAGE,ROCKTOMB
  AbilityIndex = 0
  IV = 20,20,20,20,20,20
  Hue = 150
```

### Hue editor

![editor](https://user-images.githubusercontent.com/63038410/277105241-c0ac83b4-c0ee-4942-9720-c8df3598e7b0.gif)

The editor can modify the hue of a pokémon showing the current color.

### Palette swap

<img width="515px" src="https://gist.github.com/user-attachments/assets/adb5bce6-812b-40dd-ad06-6bc76fb8b4a4">

> [!WARNING]
> This feature is cpu intensive so it may cause some game freezes.

#### GIMP guide

In order to change the pokémon's palette you will have to define the colors that will be changed and the new colors that will replace those colors.

In GIMP:

1. Create a new canvas and import all the sprites that will be modified;

<details>
	<summary>Show</summary>
	
![image](https://gist.github.com/user-attachments/assets/1a7fc2e2-8b20-4c46-b2ef-9395168008aa)
	
</details>

2. Dispose the sprites (vertically) in the canvas (the order will determine the colors that will appear in the palette);
3. Select the `Palettes` tab, right click any of the palettes, then `Import Palette...`;

<details>
	<summary>Show</summary>
	
![Image](https://gist.github.com/user-attachments/assets/881b4acd-cb2c-452d-8849-dbe997c9eb61)
	
</details>

4. Select `Image` then click `Import` (keep in mind the name of the palette, in the example it is "\[Untitled\]-1");

<details>
	<summary>Show</summary>
	
![Image](https://gist.github.com/user-attachments/assets/dc317ca6-e753-452d-81d0-026d082abb7c)
	
</details>

5. Modify the sprite colors;
6. Create a new palette with the new sprites (make sure the number of colors are the same or you will have to offset it by hand);

<details>
	<summary>Show</summary>
	
![image](https://gist.github.com/user-attachments/assets/08915836-4ed1-42fc-b905-e3d4e421460f)
	
</details>

7. Save the palettes (individually) by doing right click on them, `Export as` and `Text file...`;

<details>
	<summary>Show</summary>
	
![Image](https://gist.github.com/user-attachments/assets/32be8699-4233-4420-8681-daa54182528c)
	
</details>

8. Set the palettes by code;

<details>
	<summary>Show</summary>
	
```ruby
pokemon = Pokemon.new(:ARCANINE, 50)
pokemon.palette_0 =
	"#d5bd94
	#d8d0c0
	#000000
	#101010
	#b8a098
	#484018
	#b49c00
	#f6e6bd
	#ffeee6
	#a4946a
	#a88830
	#e8c048
	#e6d529
	#734a00
	#f6ff7b
	#303030
	#585858
	#836a62
	#786050
	#806828
	#e8e8f8
	#b0b0d0
	#deded5
	#fffff6"
pokemon.palette_1 = 
	"#535353
	#5f5f5f
	#000000
	#101010
	#404040
	#311c1c
	#5f1612
	#636363
	#696969
	#353535
	#5a262a
	#763135
	#752c23
	#431219
	#7f5647
	#303030
	#585858
	#4a3c44
	#5e4648
	#492326
	#e8e8f8
	#b0b0d0
	#aeaeac
	#cdcdc7"
pbAddPokemon(pokemon)
```
	
</details>

9. Enjoy!

#### Trainer
In the trainer PBS, the palette shall be defined in the same row and without the hash symbol.

```
Pokemon = ONIX,10
  Gender = male
  Moves = HEADSMASH,ROCKTHROW,RAGE,ROCKTOMB
  AbilityIndex = 0
  IV = 20,20,20,20,20,20
  Palette_0 = 123456 ff00ff
  Palette_1 = 654321 f1f2f3
```

<br>

## Informations
| Information                                 | Description                                                        |
| :------------------------------------------ | :----------------------------------------------------------------- |
| `pokemon.hue = 180`                         | Get/set the pokémon's hue.                                         |
| `pokemon.set_random_hue()`                  | Set a random hue to the pokémon.                                   |
| `pokemon.hue?`                              | Return `true` if the pokémon has an hue value, otherwise `false`.  |
| `pokemon.applicable_hue?`                   | Check if the pokémon's hue can be applied.                         |
| `pokemon.palette_0 = "#f9f9f9\n#010101"`    | Get/set the pokémon's source palette.                              |
| `pokemon.palette_1 = "#123456\n#ffffff"`    | Get/set the pokémon's new palette.                         |
| `pokemon.palette?`                          | Return `true` if the pokémon has a new palette, otherwise `false`. |
| `pokemon.applicable_palette?`               | Check if the pokémon's palette can be applied.                     |
| `pbHueEditor(pokemon, can_be_saved = true)` | Show the hue editor for the given pokémon.                         |
| `bitmap.hue = 10`                           | Set the bitmap's hue to the given value (from 0).                  |

### Configuration
The configuration files can be found in the `config` folder.

Make sure to create a backup of the previous files in order to update the plugin without lose your configurations.

<br>

<hr>

> Pokémon Color Variants is a plugin for *Pokémon Essentials* that brings more colors to the pokémons.
It is achieved by shifting the hue color of the sprites to make them appear different and unique.
It is all done by using the *hue_change* method that is implemented in the class *Bitmap* of *RGSS3*.

<a href="https://github.com/MickTK/PE-Pokemon-Color-Variants"><img width="25px" src="https://user-images.githubusercontent.com/63038410/277105894-4c82662e-5d30-4d2f-b2bc-4a73fc8a1837.png"></a>
<a href="https://eeveeexpo.com/resources/1035/"><img width="25px" src="https://github.com/MickTK/PE-Pokemon-Color-Variants/assets/63038410/4db3344e-b75a-42c5-8ebc-1a5a6a2796dc"></a>
