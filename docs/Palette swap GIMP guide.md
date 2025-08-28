# Palette swap GIMP guide

<img width="515px" src="https://gist.github.com/user-attachments/assets/adb5bce6-812b-40dd-ad06-6bc76fb8b4a4">

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
pokemon.shiny = true
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
