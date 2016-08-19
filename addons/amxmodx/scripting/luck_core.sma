#include <amxmodx>
#define PLUGIN "Luck Mod Core"
#define VERSION "1.0"
#define AUTHOR "swampdog@modriot.com"
new lucklow, luckhigh, lucky, unlucky;
new low, high, limit;
new lucknum[33];
public plugin_init()
{
	register_plugin(PLUGIN, VERSION, AUTHOR);
	// low end for random number generation (default 1)
	lucklow = register_cvar("luck_low","1");
	// high end for random number generation (default 100)
	luckhigh = register_cvar("luck_high","100");
	// random number generated must be higher than this for player to be "lucky" (default "50" [50/50 chance of a number from 1 to 100])
	lucky = register_cvar("lucky_limit","50");
	// random number generated must be lower than this for player to be "unlucky" (default "50" [50/50 chance of a number from 1 to 100])
	unlucky = register_cvar("unlucky_limit","50");
}
public plugin_natives()
{
	register_library("luck");
	
	register_native("is_lucky", "_is_lucky");
	register_native("is_unlucky", "_is_unlucky");
	register_native("get_luck","_get_luck");
	register_native("set_luck","_set_luck");
	register_native("add_luck","_add_luck");
	register_native("remove_luck","_remove_luck");
}
// add to user luck stats
public _is_lucky(plugin, params)
{
	if(params != 1)
		return PLUGIN_CONTINUE;

	new id = get_param(1);
	
	if(!id)
		return PLUGIN_CONTINUE;
	
	low = get_pcvar_num(lucklow);
	high = get_pcvar_num(luckhigh);
	limit = get_pcvar_num(lucky);
	
	new luck = random_num(low,high);

	if(luck < limit)
		return PLUGIN_CONTINUE;

	lucknum[id]+=1
	
	return PLUGIN_HANDLED
}
// remove from user luck stats
public _is_unlucky(plugin, params)
{
	if(params != 1)
		return PLUGIN_CONTINUE;

	new id = get_param(1);
	
	if(!id)
		return PLUGIN_CONTINUE;
	
	low = get_pcvar_num(lucklow);
	high = get_pcvar_num(luckhigh);
	limit = get_pcvar_num(unlucky);
	
	new luck = random_num(low,high);
	
	if(luck > limit)
		return PLUGIN_CONTINUE;

	lucknum[id]-=1;
	
	return PLUGIN_HANDLED;
}
// return value of player's luck stats
public _get_luck(plugin, params)
{
	if(params != 1)
		return PLUGIN_CONTINUE;

	new id = get_param(1);
	
	if(!id)
		return PLUGIN_CONTINUE;

	new value = lucknum[id];
	
	return value;
}
// sets user's luck stats to value and returns value
public _set_luck(plugin, params)
{
	if(params != 2)
		return PLUGIN_CONTINUE;

	new id = get_param(1);
	new value = get_param(2);
	
	if(!id || !value)
		return PLUGIN_CONTINUE;

	lucknum[id]=value;

	return value;	
}
// adds to user's luck stats and returns how much is added
public _add_luck(plugin, params)
{
	if(params != 2)
		return PLUGIN_CONTINUE;

	new id = get_param(1);
	new value = get_param(2);
	
	if(!id || !value)
		return PLUGIN_CONTINUE;

	lucknum[id]+=value;

	return value;	
}
// subtracts from user's luck stats and returns how much is subtracted
public _remove_luck(plugin, params)
{
	if(params != 2)
		return PLUGIN_CONTINUE;

	new id = get_param(1);
	new value = get_param(2);
	
	if(!id || !value)
		return PLUGIN_CONTINUE;

	lucknum[id]-=value;

	return value;	
}