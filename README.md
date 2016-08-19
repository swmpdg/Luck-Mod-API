# Luck-Mod-API

-------

Luck Mod API - AMX Mod X Plugin - Random number "Luck" system for mods

Written by Swamp Dog @ ModRiot.com August 18-19, 2016

For use as a base "Luck" system for mods, or to be used as a "Luck Mod". 

Can be expanded into a full "Luck Mod" with individual sub-plugins, such as the example plugin "luck_health.sma".

Example plugin included with Luck Core plugin.

To use other plugins with this Core plugin, add them to /addons/amxmodx/configs/plugins-luck.ini

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

Natives which can be used with other plugins to expand "Luck Mod":

/**
 * Checks whether a player is "lucky" or not, and incrementally counts upward by 1 if lucky.
 * 
 * @param		id - Unique index of a player
 * 
 * @return		True if lucky, false otherwise
 * 
 * @note		Variables are configured by Cvars "luck_low", "luck_high", and "lucky_limit"
 */
native is_lucky(id);

/**
 * Checks whether a player is "unlucky" or not, and decrementally counts downward by 1 if unlucky.
 * 
 * @param		id - Unique index of a player
 * 
 * @return		True if unlucky, false otherwise
 * 
 * @note		Variables are configured by Cvars "luck_low", "luck_high", and "unlucky_limit"
 */
native is_unlucky(id);

/**
 * Retrieves how much luck a player has
 * 
 * @param		id - Unique index of player
 * 
 * @return		The value of luck a player has
 * 
 * @note		Every time a user is lucky or unlucky, the luck will be counted
 */
native get_luck(id);

/**
 * Sets Luck stats of a player to specified value
 * 
 * @param		id - Unique index of player
 *
 * @param		value - Numer to set a player's luck stats to
 * 
 * @return		The value of luck a player has
 * 
 * @note		Every time a user is lucky or unlucky, the luck will be counted
 */
native set_luck(id, value);

/**
 * Adds Luck stats to a player
 * 
 * @param		id - Unique index of player
 *
 * @param		value - Numer to add to a player's luck stats
 * 
 * @return		The value of luck added to the player
 * 
 * @note		Every time a user is lucky or unlucky, the luck will be counted
 */
native add_luck(id, value);

/**
 * Subtracts Luck stats from a player
 * 
 * @param		id - Unique index of player
 *
 * @param		value - Numer to subtracted from a player's luck stats
 * 
 * @return		The value of luck a player has subtracted
 * 
 * @note		Every time a user is lucky or unlucky, the luck will be counted
 */
native remove_luck(id, value);