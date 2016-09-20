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

// Luck Mod Core configuration file cvars - found in /addons/amxmodx/configs/luck.cfg and /addons/amxmodx/scripting/luck_core.sma

// to turn debug logging messages on, set luck_debug to 1, otherwise set to 0.
luck_debug 0

// low end for good luck random number generation (default 1)
goodluck_low 1

// high end for random number generation (default 100)
goodluck_high 100

// random number generated must be HIGHER than this for player to be "lucky" (default "50" [50/50 chance of a number from 1 to 100])
lucky_limit 50

// low end for bad luck random number generation (default 1)
badluck_low 1

// high end for bad luck random number generation (default 100)
badluck_high 100

// random number generated must be LOWER than this for player to be "unlucky" (default "50" [50/50 chance of a number from 1 to 100])
unlucky_limit 50

// to add luck stats when player is lucky, set this to 1, otherwise set to 0.
add_luck 1

// to subtract luck stats when player is unlucky, set this to 1, otherwise set to 0.
sub_luck 1

// to add chance stats when player is lucky to increase chance stats, set this to 1, otherwise set to 0.
add_chance 1

// to subtract chances when player is unlucky to decrease chance stats, set this to 1, otherwise set to 0.
sub_chance 0

// to add good luck stats when player is lucky, set this to 1, otherwise set to 0.
add_goodluck 1

// to subtract good luck stats when player is unlucky, set this to 1, otherwise set to 0.
sub_goodluck 1

// to add bad luck stats when player is unlucky, set this to 1, otherwise set to 0.
add_badluck 1

// to subtract bad luck stats when player is lucky, set this to 1, otherwise set to 0.
sub_badluck 1

// to count how many chances ("risks") a player has had altogether, set this to 1, otherwise set to 0.
risk_count 1

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