/*
August 18-19, 2016
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
 * Checks whether a player is "lucky" or not, and incrementally counts upward by 1 if lucky.
 * 
 * @param		id - Unique index of a player
 * 
 * @return		True if lucky, false otherwise
 * 
 * @note		Variables are configured by Cvars "luck_low", "luck_high", and "lucky_limit"
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
 * @note		Variables are configured by Cvars "luck_low", "luck_high", and "unlucky_limit"
 *
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
 *
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
 *
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
 *
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
 *
 */
native remove_luck(id, value);