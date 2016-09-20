/*
"luck.inc" 
Originally created August 18-19, 2016
Last updated September 19, 2016
AMXX Luck API core plugin by Swamp Dog @ ModRiot.com
"AMXX Luck API" can be used as a luck-based system for other mods.
*/

#if defined _luck_included
	#endinput
#endif

#define _luck_included

#if AMXX_VERSION_NUM >= 175
	#pragma reqlib luck
	#if !defined AMXMODX_NOAUTOLOAD
		#pragma loadlib luck
	#endif
#else
	#pragma library luck
#endif

/**
 * Checks whether debug mode should be turned on or not. It will only check if a sub-plugin calls it.
 * 
 * @param		none?
 * 
 * @return		True if debugging turned on by setting the cvar "luck_debug" to 1, false otherwise. Set to 0 to turn off debugging.
 * 
 * @note		This function may not work properly without having parameters sent to the Luck Mod Core module. May need to replace with a stock.
 *
 */
native in_debug();

/**
 * Checks whether a player is "loaded" or not. Player must be set as "loaded" for certain plugins.
 * 
 * @param		id - Unique index of a player
 * 
 * @return		True if player is has been set as loaded, false otherwise
 * 
 * @note		If a player isn't set loaded with the set_loaded(id) native, this will return false.
 *
 */
native has_loaded(id);

/**
 * Sets a player is "loaded". Player must be set as "loaded" for certain plugins.
 * 
 * @param		id - Unique index of a player
 * 
 * @return		True if player is set loaded properly, false otherwise
 * 
 * @note		This is to be used to set players as loaded to function with Luck Mod core. A check is done with has_loaded(id) native to prevent certain functions until set.
 *
 */
native set_loaded(id);

/**
 * Checks whether a player is "lucky" or not, and incrementally counts upward by 1 if lucky.
 * 
 * @param		id - Unique index of a player
 * 
 * @return		True if lucky, false otherwise
 * 
 * @note		Variables are configured by Cvars "goodluck_low", "goodluck_high", and "lucky_limit"
 *
 */
native is_lucky(id);

/**
 * Checks whether a player is "unlucky" or not, and decrementally counts downward by 1 if unlucky.
 * 
 * @param		id - Unique index of a player
 * 
 * @return		True if unlucky, false otherwise
 * 
 * @note		Variables are configured by Cvars "badluck_low", "badluck_high", and "unlucky_limit"
 *
 */
native is_unlucky(id);

/**
 * Checks whether a player has luck or not
 * 
 * @param		id - Unique index of a player
 * 
 * @return		True if player has luck, false otherwise
 * 
 * @note
 *
 */
native has_luck(id);

/**
 * Checks whether a player has good luck or not
 * 
 * @param		id - Unique index of a player
 * 
 * @return		True if player has good luck, false otherwise
 * 
 * @note
 *
 */
native has_good_luck(id);

/**
 * Checks whether a player has bad luck or not
 * 
 * @param		id - Unique index of a player
 * 
 * @return		True if player has bad luck, false otherwise
 * 
 * @note
 *
 */
native has_bad_luck(id);

/**
 * Retrieves how much luck a player has
 * 
 * @param		id - Unique index of player
 * 
 * @return		The value of luck a player has on success, PLUGIN_CONTINUE on failure 
 * 
 * @note		Every time a user is lucky or unlucky, the luck will be counted
 *
 */
native get_luck(id);

/**
 * Retrieves the minimum amount of luck a player can have
 * 
 * @param		id - Unique index of player
 * 
 * @return		The minimum value of luck a player can have on success, PLUGIN_CONTINUE on failure 
 * 
 * @note
 *
 */
native get_min_luck(id);

/**
 * Retrieves the maximum amount of luck a player can have
 * 
 * @param		id - Unique index of player
 * 
 * @return		The maximum value of luck a player can have on success, PLUGIN_CONTINUE on failure 
 * 
 * @note
 *
 */
native get_max_luck(id);

/**
 * Retrieves how much good luck a player has
 * 
 * @param		id - Unique index of player
 * 
 * @return		The value of good luck a player has on success, PLUGIN_CONTINUE on failure 
 * 
 * @note		Every time a user is lucky or unlucky, the luck will be counted
 *
 */
native get_good_luck(id);

/**
 * Retrieves the minimum amount of good luck a player can have
 * 
 * @param		id - Unique index of player
 * 
 * @return		The minimum value of good luck a player can have on success, PLUGIN_CONTINUE on failure 
 * 
 * @note
 *
 */
native get_min_good(id);

/**
 * Retrieves the maximum amount of good luck a player can have
 * 
 * @param		id - Unique index of player
 * 
 * @return		The maximum value of good luck a player can have on success, PLUGIN_CONTINUE on failure 
 * 
 * @note
 *
 */
native get_max_good(id);

/**
 * Retrieves how much bad luck a player has
 * 
 * @param		id - Unique index of player
 * 
 * @return		The value of bad luck a player has on success, PLUGIN_CONTINUE on failure 
 * 
 * @note		Every time a user is lucky or unlucky, the luck will be counted
 *
 */
native get_bad_luck(id);

/**
 * Retrieves the minimum amount of bad luck a player can have
 * 
 * @param		id - Unique index of player
 * 
 * @return		The minimum value of bad luck a player can have on success, PLUGIN_CONTINUE on failure 
 * 
 * @note
 *
 */
native get_min_bad(id);

/**
 * Retrieves the maximum amount of bad luck a player can have
 * 
 * @param		id - Unique index of player
 * 
 * @return		The maximum value of bad luck a player can have on success, PLUGIN_CONTINUE on failure 
 * 
 * @note
 *
 */
native get_max_bad(id);

/**
 * Sets Luck stats of a player to specified value
 * 
 * @param		id - Unique index of player
 *
 * @param		value - Number to set a player's luck stats to
 * 
 * @return		PLUGIN_HANDLED on success, PLUGIN_CONTINUE on failure
 * 
 * @note		This value will change as soon as luck is checked again unless restricted from doing so
 *
 */
native set_luck(id, value);

/**
 * Sets minimum amount of luck a player can have to a specified value
 * 
 * @param		id - Unique index of player
 *
 * @param		value - Number to set a player's minimum amount of luck to
 * 
 * @return		PLUGIN_HANDLED on success, PLUGIN_CONTINUE on failure
 * 
 * @note
 *
 */
native set_min_luck(id, value);

/**
 * Sets maximum amount of luck a player can have to a specified value
 * 
 * @param		id - Unique index of player
 *
 * @param		value - Number to set a player's maximum amount of luck to
 * 
 * @return		PLUGIN_HANDLED on success, PLUGIN_CONTINUE on failure
 * 
 * @note
 *
 */
native set_max_luck(id, value);

/**
 * Sets Good Luck stats of a player to specified value
 * 
 * @param		id - Unique index of player
 *
 * @param		value - Number to set a player's good luck stats to
 * 
 * @return		PLUGIN_HANDLED on success, PLUGIN_CONTINUE on failure
 * 
 * @note		This value will change as soon as luck is checked again unless restricted from doing so
 *
 */
native set_good_luck(id, value);

/**
 * Sets minimum amount of good luck a player can have to a specified value
 * 
 * @param		id - Unique index of player
 *
 * @param		value - Number to set a player's minimum amount of good luck to
 * 
 * @return		PLUGIN_HANDLED on success, PLUGIN_CONTINUE on failure
 * 
 * @note
 *
 */
native set_min_good(id, value);

/**
 * Sets maximum amount of good luck a player can have to a specified value
 * 
 * @param		id - Unique index of player
 *
 * @param		value - Number to set a player's maximum amount of good luck to
 * 
 * @return		PLUGIN_HANDLED on success, PLUGIN_CONTINUE on failure
 * 
 * @note
 *
 */
native set_max_good(id, value);

/**
 * Sets Bad Luck stats of a player to specified value
 * 
 * @param		id - Unique index of player
 *
 * @param		value - Number to set a player's bad luck stats to
 * 
 * @return		PLUGIN_HANDLED on success, PLUGIN_CONTINUE on failure
 * 
 * @note		This value will change as soon as luck is checked again unless restricted from doing so
 *
 */
native set_bad_luck(id, value);

/**
 * Sets minimum amount of bad luck a player can have to a specified value
 * 
 * @param		id - Unique index of player
 *
 * @param		value - Number to set a player's minimum amount of bad luck to
 * 
 * @return		PLUGIN_HANDLED on success, PLUGIN_CONTINUE on failure
 * 
 * @note
 *
 */
native set_min_bad(id, value);

/**
 * Sets maximum amount of bad luck a player can have to a specified value
 * 
 * @param		id - Unique index of player
 *
 * @param		value - Number to set a player's maximum amount of bad luck to
 * 
 * @return		PLUGIN_HANDLED on success, PLUGIN_CONTINUE on failure
 * 
 * @note
 *
 */
native set_max_bad(id, value);

/**
 * Adds Luck stats to a player
 * 
 * @param		id - Unique index of player
 *
 * @param		value - Number to add to a player's luck stats
 * 
 * @return		PLUGIN_HANDLED on success, PLUGIN_CONTINUE on failure
 * 
 * @note		This value will change as soon as luck is checked again unless restricted from doing so
 *
 */
native add_luck(id, value);

/**
 * Adds on to the minimum amount of luck a player can have
 * 
 * @param		id - Unique index of player
 *
 * @param		value - Number to add to a player's minimum amount of luck
 * 
 * @return		PLUGIN_HANDLED on success, PLUGIN_CONTINUE on failure
 * 
 * @note
 *
 */
native add_min_luck(id, value);

/**
 * Adds on to the maximum amount of luck a player can have
 * 
 * @param		id - Unique index of player
 *
 * @param		value - Number to add to a player's maximum amount of luck
 * 
 * @return		PLUGIN_HANDLED on success, PLUGIN_CONTINUE on failure
 * 
 * @note
 *
 */
native add_max_luck(id, value);

/**
 * Adds Good Luck stats to a player
 * 
 * @param		id - Unique index of player
 *
 * @param		value - Number to add to a player's good luck stats
 * 
 * @return		PLUGIN_HANDLED on success, PLUGIN_CONTINUE on failure
 * 
 * @note		This value will change as soon as luck is checked again unless restricted from doing so
 *
 */
native add_good_luck(id, value);

/**
 * Adds on to the minimum amount of good luck a player can have
 * 
 * @param		id - Unique index of player
 *
 * @param		value - Number to add to a player's minimum amount of good luck
 * 
 * @return		PLUGIN_HANDLED on success, PLUGIN_CONTINUE on failure
 * 
 * @note
 *
 */
native add_min_good(id, value);

/**
 * Adds on to the maximum amount of good luck a player can have
 * 
 * @param		id - Unique index of player
 *
 * @param		value - Number to add to a player's maximum amount of good luck
 * 
 * @return		PLUGIN_HANDLED on success, PLUGIN_CONTINUE on failure
 * 
 * @note
 *
 */
native add_max_good(id, value);

/**
 * Adds Bad Luck stats to a player
 * 
 * @param		id - Unique index of player
 *
 * @param		value - Number to add to a player's bad luck stats
 * 
 * @return		PLUGIN_HANDLED on success, PLUGIN_CONTINUE on failure
 * 
 * @note		This value will change as soon as luck is checked again unless restricted from doing so
 *
 */
native add_bad_luck(id, value);

/**
 * Adds on to the minimum amount of bad luck a player can have
 * 
 * @param		id - Unique index of player
 *
 * @param		value - Number to add to a player's minimum amount of bad luck
 * 
 * @return		PLUGIN_HANDLED on success, PLUGIN_CONTINUE on failure
 * 
 * @note
 *
 */
native add_min_bad(id, value);

/**
 * Adds on to the maximum amount of bad luck a player can have
 * 
 * @param		id - Unique index of player
 *
 * @param		value - Number to add to a player's maximum amount of bad luck
 * 
 * @return		PLUGIN_HANDLED on success, PLUGIN_CONTINUE on failure
 * 
 * @note
 *
 */
native add_max_bad(id, value);

/**
 * Subtracts Luck stats from a player
 * 
 * @param		id - Unique index of player
 *
 * @param		value - Number to subtracted from a player's luck stats
 * 
 * @return		PLUGIN_HANDLED on success, PLUGIN_CONTINUE on failure
 * 
 * @note		This value will change as soon as luck is checked again unless restricted from doing so
 *
 */
native sub_luck(id, value);

/**
 * Subtracts from the minimum amount of luck a player can have
 * 
 * @param		id - Unique index of player
 *
 * @param		value - Number to subtracted from a player's minimum amount of luck
 * 
 * @return		PLUGIN_HANDLED on success, PLUGIN_CONTINUE on failure
 * 
 * @note
 *
 */
native sub_min_luck(id, value);

/**
 * Subtracts from the maximum amount of luck a player can have
 * 
 * @param		id - Unique index of player
 *
 * @param		value - Number to subtracted from a player's maximum amount of luck
 * 
 * @return		PLUGIN_HANDLED on success, PLUGIN_CONTINUE on failure
 * 
 * @note
 *
 */
native sub_max_luck(id, value);

/**
 * Subtracts Good Luck stats from a player
 * 
 * @param		id - Unique index of player
 *
 * @param		value - Number to subtracted from a player's good luck stats
 * 
 * @return		PLUGIN_HANDLED on success, PLUGIN_CONTINUE on failure
 * 
 * @note		This value will change as soon as luck is checked again unless restricted from doing so
 *
 */
native sub_good_luck(id, value);

/**
 * Subtracts from the minimum amount of good luck a player can have
 * 
 * @param		id - Unique index of player
 *
 * @param		value - Number to subtracted from a player's minimum amount of good luck
 * 
 * @return		PLUGIN_HANDLED on success, PLUGIN_CONTINUE on failure
 * 
 * @note
 *
 */
native sub_min_good(id, value);

/**
 * Subtracts from the maximum amount of good luck a player can have
 * 
 * @param		id - Unique index of player
 *
 * @param		value - Number to subtracted from a player's maximum amount of good luck
 * 
 * @return		PLUGIN_HANDLED on success, PLUGIN_CONTINUE on failure
 * 
 * @note
 *
 */
native sub_max_good(id, value);

/**
 * Subtracts Bad Luck stats from a player
 * 
 * @param		id - Unique index of player
 *
 * @param		value - Number to subtracted from a player's bad luck stats
 * 
 * @return		PLUGIN_HANDLED on success, PLUGIN_CONTINUE on failure
 * 
 * @note		This value will change as soon as luck is checked again unless restricted from doing so
 *
 */
native sub_bad_luck(id, value);

/**
 * Subtracts from the minimum amount of bad luck a player can have
 * 
 * @param		id - Unique index of player
 *
 * @param		value - Number to subtracted from a player's minimum amount of bad luck
 * 
 * @return		PLUGIN_HANDLED on success, PLUGIN_CONTINUE on failure
 * 
 * @note
 *
 */
native sub_min_bad(id, value);

/**
 * Subtracts from the maximum amount of bad luck a player can have
 * 
 * @param		id - Unique index of player
 *
 * @param		value - Number to subtracted from a player's maximum amount of bad luck
 * 
 * @return		PLUGIN_HANDLED on success, PLUGIN_CONTINUE on failure
 * 
 * @note
 *
 */
native sub_max_bad(id, value);

/**
 * Checks whether a player has any chances or not
 * 
 * @param		id - Unique index of a player
 * 
 * @return		True if player has chances, false otherwise
 * 
 * @note
 *
 */
native has_chance(id);

/**
 * Retrieves how many chances a player has had to either be lucky or unlucky
 * 
 * @param		id - Unique index of player
 * 
 * @return		The number of chances a player has had on success, or PLUGIN_CONTINUE on failure
 * 
 * @note		Every time a user is check whether lucky or unlucky, the chance will be counted even if there is no result
 *
 */
native get_chance(id);

/**
 * Retrieves the minimum amount of chances a player can have
 * 
 * @param		id - Unique index of player
 * 
 * @return		The minimum value of chances a player can have on success, PLUGIN_CONTINUE on failure 
 * 
 * @note
 *
 */
native get_min_chance(id);

/**
 * Retrieves the maximum amount of chances a player can have
 * 
 * @param		id - Unique index of player
 * 
 * @return		The maximum value of chances a player can have on success, PLUGIN_CONTINUE on failure 
 * 
 * @note
 *
 */
native get_max_chance(id);

/**
 * Sets number of chances a player has to specified value
 * 
 * @param		id - Unique index of player
 *
 * @param		value - Number to set a player's chances stats to
 * 
 * @return		PLUGIN_HANDLED on success, PLUGIN_CONTINUE on failure
 * 
 * @note		This value will change as soon as luck is checked again unless restricted from doing so
 *
 */
native set_chance(id, value);

/**
 * Sets minimum amount of chances a player has to specified value
 * 
 * @param		id - Unique index of player
 *
 * @param		value - Number to set a player's minimum chances to
 * 
 * @return		PLUGIN_HANDLED on success, PLUGIN_CONTINUE on failure
 * 
 * @note
 *
 */
native set_min_chance(id, value);

/**
 * Sets maximum amount of chances a player has to specified value
 * 
 * @param		id - Unique index of player
 *
 * @param		value - Number to set a player's maximum chances to
 * 
 * @return		PLUGIN_HANDLED on success, PLUGIN_CONTINUE on failure
 * 
 * @note
 *
 */
native set_max_chance(id, value);

/**
 * Adds chances to a player
 * 
 * @param		id - Unique index of player
 *
 * @param		value - Number to add to a player's chance stats
 * 
 * @return		PLUGIN_HANDLED on success, PLUGIN_CONTINUE on failure
 * 
 * @note		This value will change as soon as luck is checked again unless restricted from doing so
 *
 */
native add_chance(id, value);

/**
 * Adds on to minimum chances a player has
 * 
 * @param		id - Unique index of player
 *
 * @param		value - Number to add to a player's minimum chances
 * 
 * @return		PLUGIN_HANDLED on success, PLUGIN_CONTINUE on failure
 * 
 * @note
 *
 */
native add_min_chance(id, value);

/**
 * Adds on to maximum chances a player has
 * 
 * @param		id - Unique index of player
 *
 * @param		value - Number to add to a player's maximum chances
 * 
 * @return		PLUGIN_HANDLED on success, PLUGIN_CONTINUE on failure
 * 
 * @note
 *
 */
native add_max_chance(id, value);

/**
 * Subtracts chances from a player
 * 
 * @param		id - Unique index of player
 *
 * @param		value - Number to subtracted from a player's chance stats
 * 
 * @return		PLUGIN_HANDLED on success, PLUGIN_CONTINUE on failure
 * 
 * @note		This value will change as soon as luck is checked again unless restricted from doing so
 *
 */
native sub_chance(id, value);

/**
 * Subtracts from number of minimum chances a player has
 * 
 * @param		id - Unique index of player
 *
 * @param		value - Number to subtracted from a player's maximum chances
 * 
 * @return		PLUGIN_HANDLED on success, PLUGIN_CONTINUE on failure
 * 
 * @note
 *
 */
native sub_min_chance(id, value);

/**
 * Subtracts from number of maximum chances a player has
 * 
 * @param		id - Unique index of player
 *
 * @param		value - Number to subtracted from a player's maximum chances
 * 
 * @return		PLUGIN_HANDLED on success, PLUGIN_CONTINUE on failure
 * 
 * @note
 *
 */
native sub_max_chance(id, value);

/**
 * Checks whether a player has any risks or not
 * 
 * @param		id - Unique index of a player
 * 
 * @return		True if player has risked more than once, false otherwise
 * 
 * @note
 *
 */
native has_risk(id);

/**
 * Retrieves how many risks a player has had to either be lucky or unlucky
 * 
 * @param		id - Unique index of player
 * 
 * @return		The number of risks a player has had on success, or PLUGIN_CONTINUE on failure
 * 
 * @note		Every time a user is check whether lucky or unlucky, the chance will be counted even if there is no result
 *
 */
native get_risk(id);

/**
 * Retrieves the minimum amount of risks a player can have
 * 
 * @param		id - Unique index of player
 * 
 * @return		The minimum value of risks a player can have on success, PLUGIN_CONTINUE on failure 
 * 
 * @note
 *
 */
native get_min_risk(id);

/**
 * Retrieves the maximum amount of risks a player can have
 * 
 * @param		id - Unique index of player
 * 
 * @return		The maximum value of risks a player can have on success, PLUGIN_CONTINUE on failure 
 * 
 * @note
 *
 */
native get_max_risk(id);

/**
 * Sets number of risks a player has to specified value
 * 
 * @param		id - Unique index of player
 *
 * @param		value - Number to set a player's risk stats to
 * 
 * @return		PLUGIN_HANDLED on success, PLUGIN_CONTINUE on failure
 * 
 * @note		This value will change as soon as luck is checked again unless restricted from doing so
 *
 */
native set_risk(id, value);

/**
 * Sets minimum amount of risks a player has to specified value
 * 
 * @param		id - Unique index of player
 *
 * @param		value - Number to set a player's minimum risks to
 * 
 * @return		PLUGIN_HANDLED on success, PLUGIN_CONTINUE on failure
 * 
 * @note
 *
 */
native set_min_risk(id, value);

/**
 * Sets maximum amount of risks a player has to specified value
 * 
 * @param		id - Unique index of player
 *
 * @param		value - Number to set a player's maximum risks to
 * 
 * @return		PLUGIN_HANDLED on success, PLUGIN_CONTINUE on failure
 * 
 * @note
 *
 */
native set_max_risk(id, value);

/**
 * Adds risks to a player
 * 
 * @param		id - Unique index of player
 *
 * @param		value - Number to add to a player's risk stats
 * 
 * @return		PLUGIN_HANDLED on success, PLUGIN_CONTINUE on failure
 * 
 * @note		This value will change as soon as luck is checked again unless restricted from doing so
 *
 */
native add_risk(id, value);

/**
 * Adds on to minimum risks a player has
 * 
 * @param		id - Unique index of player
 *
 * @param		value - Number to add to a player's minimum risks
 * 
 * @return		PLUGIN_HANDLED on success, PLUGIN_CONTINUE on failure
 * 
 * @note
 *
 */
native add_min_risk(id, value);

/**
 * Adds on to maximum risks a player has
 * 
 * @param		id - Unique index of player
 *
 * @param		value - Number to add to a player's maximum risks
 * 
 * @return		PLUGIN_HANDLED on success, PLUGIN_CONTINUE on failure
 * 
 * @note
 *
 */
native add_max_risk(id, value);

/**
 * Subtracts risks from a player
 * 
 * @param		id - Unique index of player
 *
 * @param		value - Number to subtracted from a player's risk stats
 * 
 * @return		PLUGIN_HANDLED on success, PLUGIN_CONTINUE on failure
 * 
 * @note		This value will change as soon as luck is checked again unless restricted from doing so
 *
 */
native sub_risk(id, value);

/**
 * Subtracts from number of minimum risks a player has
 * 
 * @param		id - Unique index of player
 *
 * @param		value - Number to subtracted from a player's maximum risks
 * 
 * @return		PLUGIN_HANDLED on success, PLUGIN_CONTINUE on failure
 * 
 * @note
 *
 */
native sub_min_risk(id, value);

/**
 * Subtracts from number of maximum risks a player has
 * 
 * @param		id - Unique index of player
 *
 * @param		value - Number to subtracted from a player's maximum risks
 * 
 * @return		PLUGIN_HANDLED on success, PLUGIN_CONTINUE on failure
 * 
 * @note
 *
 */
native sub_max_risk(id, value);