# Player tools 1.6 [playertools]
Fixed and modified version from https://forum.minetest.net/viewtopic.php?t=7498  
This mod adds some player-related server commands and privileges to Minetest.
Most commands are little helper tools, useful for modders and for messing
around, but they aren’t really suitable for serious gameplay. Some commands
are informational. The commands allow players to change their health, clear
their inventory, set their player physics, and other stuff.
The privileges are created for the health, physics and hotbar-related commands
and are named “`heal`”, “`physics`” and “`hotbar`”, respectively.

## List of commands
### No privileges required

* `/whoami`: Shows your name in your chat.
* `/ip`: Shows your IP address in your chat.
* `/pulverizeall`: Destroys all items in your inventory and crafting grid.
* `/killme`: Kills yourself.

### “`server`” privilege required
* `/ip <playername>`: Shows player's IP address in your chat.
* `/pulverizeall <playername>`: Destroys all items in player's inventory and crafting grid.

### “`hotbar`” privilege required

* `/hotbar <1...32>`: Sets the number of slots in your hotbar.

### “`heal`” privilege and damage required

* `/sethp <hp number>` Sets your health to specified number.
* `/setbreath <breath number>`: Sets your breath to specified breath points.

### “`physics`” privilege required

* `/speed [<playername>] [<speed>]`: Sets your movement speed to `<speed>` (default: 1).
* `/gravity [<playername>] [<gravity>]`: Sets your gravity to `<gravity>` (default: 1).
* `/jump [<playername>] [<height>]`: Sets your jump height to `<height>` (default: 1).
* `/stun <playername>`: Disable player's movement.
* `/unstun <playername>`: Restore player's movement.

### “`psize`” privilege required

* `/size <size>`: Change your or another player's size. Range: 0.06 - 30.

### “`ban`” privilege required

* `/xkill <playername>`: Set player's hp to 0 until rejoin (even with admin armor).
* `/xres <playername>`: Resurrect player with 0 hp



## Installation
You can either install the player tools as an ordinary mod or as a builtin,
but please don’t do both. Installing it as a mod is very easy, but you have
to activate the mod explicitly for each map. Installing it as builtin is easy
and the player tools are automatically available for every server you start.

To install it as a mod, just drop this folder into the `mods/` directory of your
Minetest data folder.

To install it as builtin do this:
(For version 0.4.9)
Rename the file “`init.lua`” to “`mod_playertools.lua`” and move it to `<your Minetest installation folder>/builtin/`.
Then edit the file `<your Minetest installation folder>/builtin/builtin.lua`. Add the following line of text at the
end of the file:

    dofile(modpath.."/mod_playertools.lua")

Save the file; you’re finished! The next time you start a server the player tools are available.

## License
This mod is free software, licensed under the MIT License.
