# A Counter-Strike: 2 Server Pug plugin written in LUA

Install the Pug plugin hassle-free with [voxbyte.io](https://voxbyte.io/en) - your one-click solution for effortless Counter-Strike 2 server hosting

## Admin Commands

- `adminlogin pw`        --allows the usage of following commands
- `startpug`             --starts the pug
- `pausepug`             --pauses the pug
- `unpausepug`           --unpauses the pug
- `restartpug`           --compleatly restarts the pug
- `scramble`             --shuffles teams
- `rewarmup`             --restarts warmup phase
- `changemap de_dust2`   --changes map
- `pugkick id`           --kicks the player (use `status` to get the player id you want to kick)

![alt text](https://i.imgur.com/mblcbTI.jpeg)

### Dependencies

This plugin requires the unlocked LUA VScript.dll on windows or the unlocked libvscript.so on Linux

Lua Patcher (use if you are not using MetaMod): https://github.com/bklol/vscriptPatch

Lua Unlocker MetaMod Plugin: https://github.com/Source2ZE/LuaUnlocker

### Installing

* Unzip into your servers csgo folder and
* Add 'exec pugplugin' to your server gamemode cfg

### Configuration

* To configure the plugin head to csgo/scripts/vscripts/pug_cfg.lua

  Feel free to change the variables to what you desire! Make sure to read their --comments
  
* To whitelist players add their SteamID3 to the allowedPlayers table in whitelist.lua


## Author
[@DEAFPS_](https://twitter.com/deafps_)
