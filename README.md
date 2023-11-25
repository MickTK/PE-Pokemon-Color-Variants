![Essentials](https://badgen.net/badge/Essentials/21.1/orange)
![Version](https://badgen.net/badge/Version/1.2.1/cyan)

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

### Editor

![editor](https://user-images.githubusercontent.com/63038410/277105241-c0ac83b4-c0ee-4942-9720-c8df3598e7b0.gif)

The editor can modify the hue of a pokémon showing the current color.

<br>

## Informations
| Information | Description |
|:-|:-|
| `pokemon.hue = 180` | Get/set the pokémon's hue. |
|`pokemon.set_random_hue()`|Set a random hue to the pokémon.|
| `pokemon.hue?` | Return `true` if the pokémon has an hue value, `false` otherwise. |
|`pokemon.applicable_hue?`| Check if the pokémon's hue can be applied.|
|`pbHueEditor(pokemon, can_be_saved = true)`| Show the hue editor for the given pokémon.|
|`bitmap.hue = 10`|Set the bitmap's hue from to the given value (from 0).|

### Configurations
The configuration files can be found in the `config` folder.

Make sure to create a backup of the previous files in order to update the plugin without lose your configurations.

<br>

<hr>

> Pokémon Color Variants is a plugin for *Pokémon Essentials* that brings more colors to the pokémons.
It is achieved by shifting the hue color of the sprites to make them appear different and unique.
It is all done by using the *hue_change* method that is implemented in the class *Bitmap* of *RGSS3*.

<a href="https://github.com/MickTK/PE-Pokemon-Color-Variants"><img width="25px" src="https://user-images.githubusercontent.com/63038410/277105894-4c82662e-5d30-4d2f-b2bc-4a73fc8a1837.png"></a>
<a href="https://reliccastle.com/resources/1035/"><img width="25px" src="https://user-images.githubusercontent.com/63038410/277105886-60e410d8-9a47-4d63-b1c0-5d67b545b7cb.png"></a>
