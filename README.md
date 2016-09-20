# Luck-Mod-API

-------

AMX Mod X Plugin - "Luck" system for Half-Life 1 mods and plugins

Written by Swamp Dog @ ModRiot.com August 18-19, 2016

Last updated September 19, 2016

For use as a base "Luck" system for mods, or to be used as a "Luck Mod".

Can be expanded into a full "Luck Mod" with individual sub-plugins, such as the example plugin "luck_health.sma".

Example plugin included with Luck Core plugin.

To use other plugins with this Core plugin, add them to /addons/amxmodx/configs/plugins-luck.ini

To change cvars with Luck Mod,, edit /addons/amxmodx/configs/luck.cfg

-------


Natives which can be used with other plugins to expand "Luck Mod":

see https://github.com/swmpdg/Luck-Mod-API/wiki/Natives for a list and link to the "luck.inc" include file.

-------

Commands (and stats saving) in example plugin "luck_health.sma":

command:
amx_setluck "Playername" "Value"

description:
Set's players luck to this value and save the stats.

command:
amx_addluck "Playername" "Value"

description:
Adds luck to player

command:
amx_removeluck "Playername" "Value"

description:
Removes luck from player

-------

Cvars in core plugin "luck_core.sma":

cvar:
luck_low "1"

description:
low end for random number generation (default 1)

cvar:
luck_high "100"

description:
high end for random number generation (default 100)

cvar:
lucky_limit	"50"

description:
random number generated must be higher than this for player to be "lucky" (default "50" [50/50 chance of a number from 1 to 100])

unlucky_limit "50"

description:
random number generated must be lower than this for player to be "unlucky" (default "50" [50/50 chance of a number from 1 to 100])

-------