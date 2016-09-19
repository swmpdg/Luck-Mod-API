#include <amxmodx>
#include <amxmisc>
#include <luck_const>

new goodlow, goodhigh, lucky;
new badlow, badhigh, unlucky;
new good_low, good_high, goodlimit;
new bad_low, bad_high, badlimit;
new addluck, subluck, addchance, subchance;
new addgood, addbad, subgood, subbad;
new riskcount;
new cvar_addluck, cvar_subluck, cvar_addchance, cvar_subchance;
new cvar_addgood, cvar_subgood, cvar_addbad, cvar_subbad;
new cvar_addrisk;
new luckdebug, debugOn;

new lucknum[LUCK_SLOTS+1], chance[LUCK_SLOTS+1];
new minluck[LUCK_SLOTS+1], maxluck[LUCK_SLOTS+1], minchance[LUCK_SLOTS+1], maxchance[LUCK_SLOTS+1];
new goodluck[LUCK_SLOTS+1], badluck[LUCK_SLOTS+1];
new mingood[LUCK_SLOTS+1], maxgood[LUCK_SLOTS+1], minbad[LUCK_SLOTS+1], maxbad[LUCK_SLOTS+1];
new risk[LUCK_SLOTS+1], minrisk[LUCK_SLOTS+1], maxrisk[LUCK_SLOTS+1];
new bool:hasLoaded[LUCK_SLOTS+1] = false;

public plugin_init()
{
	register_plugin(CORE_NAME, CORE_VERSION, CORE_AUTHOR);

	register_cvar("luck_mod_version", CORE_VERSION, FCVAR_SERVER|FCVAR_SPONLY)
	// Update incase new version loaded while still running
	set_cvar_string("luck_mod_version", CORE_VERSION);

	// low end for good luck random number generation (default 1)
	goodlow = register_cvar(GOODLOW,"1");
	// high end for random number generation (default 100)
	goodhigh = register_cvar(GOODHIGH,"100");
	// random number generated must be HIGHER than this for player to be "lucky" (default "50" [50/50 chance of a number from 1 to 100])
	lucky = register_cvar(GOODLIMIT,"50");
	// low end for bad luck random number generation (default 1)
	badlow = register_cvar(BADLOW,"1");
	// high end for bad luck random number generation (default 100)
	badhigh = register_cvar(BADHIGH,"100");
	// random number generated must be LOWER than this for player to be "unlucky" (default "50" [50/50 chance of a number from 1 to 100])
	unlucky = register_cvar(BADLIMIT,"50");
	// to add luck stats when player is lucky, set this to 1, otherwise set to 0.
	cvar_addluck = register_cvar(ADDLUCK,"1");
	// to subtract luck stats when player is unlucky, set this to 1, otherwise set to 0.
	cvar_subluck = register_cvar(SUBLUCK,"1");
	// to add chance stats when player is lucky to increase chance stats, set this to 1, otherwise set to 0.
	cvar_addchance = register_cvar(ADDCHANCE,"1");
	// to subtract chances when player is unlucky to decrease chance stats, set this to 1, otherwise set to 0.
	cvar_subchance = register_cvar(SUBCHANCE,"0");
	// to add good luck stats when player is lucky, set this to 1, otherwise set to 0.
	cvar_addgood = register_cvar(ADDGOOD,"1");
	// to subtract good luck stats when player is unlucky, set this to 1, otherwise set to 0.
	cvar_subgood = register_cvar(SUBGOOD,"1");
	// to add bad luck stats when player is unlucky, set this to 1, otherwise set to 0.
	cvar_addbad = register_cvar(ADDBAD,"1");
	// to subtract bad luck stats when player is lucky, set this to 1, otherwise set to 0.
	cvar_subbad = register_cvar(SUBBAD,"1");
	// to count how many chances ("risk") a player has had altogether, set this to 1, otherwise set to 0.
	cvar_addrisk = register_cvar(RISKS,"1");
	// tu turn debug logging messages on, set luck_debug to 1, otherwise set to 0.
	luckdebug = register_cvar(DEBUGON,"0");
}
public plugin_natives()
{
	register_library(LUCKCORE);

	register_native("in_debug","_in_debug");
	register_native("has_loaded","_has_loaded");
	register_native("set_loaded","_set_loaded");
	register_native("is_lucky", "_is_lucky");
	register_native("is_unlucky", "_is_unlucky");
	register_native("has_luck","_has_luck");
	register_native("has_good_luck","_has_good_luck");
	register_native("has_bad_luck","_has_bad_luck");
	register_native("get_luck","_get_luck");
	register_native("get_min_luck","_get_min_luck");
	register_native("get_max_luck","_get_max_luck");
	register_native("get_good_luck","_get_good_luck");
	register_native("get_min_good","_get_min_good");
	register_native("get_max_good","_get_max_good");
	register_native("get_bad_luck","_get_bad_luck");
	register_native("get_min_bad","_get_min_bad");
	register_native("get_max_bad","_get_max_bad");
	register_native("set_luck","_set_luck");
	register_native("set_min_luck","_set_min_luck");
	register_native("set_max_luck","_set_max_luck");
	register_native("set_good_luck","_set_good_luck");
	register_native("set_min_good","_set_min_good");
	register_native("set_max_good","_set_max_good");
	register_native("set_bad_luck","_set_bad_luck");
	register_native("set_min_bad","_set_min_bad");
	register_native("set_max_bad","_set_max_bad");
	register_native("add_luck","_add_luck");
	register_native("add_min_luck","_add_min_luck");
	register_native("add_max_luck","_add_max_luck");
	register_native("add_good_luck","_add_good_luck");
	register_native("add_min_good","_add_min_good");
	register_native("add_max_good","_add_max_good");
	register_native("add_bad_luck","_add_bad_luck");
	register_native("add_min_bad","_add_min_bad");
	register_native("add_max_bad","_add_max_bad");
	register_native("sub_luck","_sub_luck");
	register_native("sub_min_luck","_sub_min_luck");
	register_native("sub_max_luck","_sub_max_luck");
	register_native("sub_good_luck","_sub_good_luck");
	register_native("sub_min_good","_sub_min_good");
	register_native("sub_max_good","_sub_max_good");
	register_native("sub_bad_luck","_sub_bad_luck");
	register_native("sub_min_bad","_sub_min_bad");
	register_native("sub_max_bad","_sub_max_bad");
	register_native("has_chance","_has_chance");
	register_native("get_chance","_get_chance");
	register_native("get_min_chance","_get_min_chance");
	register_native("get_max_chance","_get_max_chance");
	register_native("set_chance","_set_chance");
	register_native("set_min_chance","_set_min_chance");
	register_native("set_max_chance","_set_max_chance");
	register_native("add_chance","_add_chance");
	register_native("add_min_chance","_add_min_chance");
	register_native("add_max_chance","_add_max_chance");
	register_native("sub_chance","_sub_chance");
	register_native("sub_min_chance","_sub_min_chance");
	register_native("sub_max_chance","_sub_max_chance");
	register_native("has_risk","_has_risk");
	register_native("get_risk","_get_risk");
	register_native("get_min_risk","_get_min_risk");
	register_native("get_max_risk","_get_max_risk");
	register_native("set_risk","_set_risk");
	register_native("set_min_risk","_set_min_risk");
	register_native("set_max_risk","_set_max_risk");
	register_native("add_risk","_add_risk");
	register_native("add_min_risk","_add_min_risk");
	register_native("add_max_risk","_add_max_risk");
	register_native("sub_risk","_sub_risk");
	register_native("sub_min_risk","_sub_min_risk");
	register_native("sub_max_risk","_sub_max_risk");
}
// execute config file after plugins load - can include multiple plugins' cvars in luck.cfg
public plugin_cfg()
{
	log_amx(MSGLOG,LUCKMSG,CORE_NAME,CORE_VERSION,CORE_AUTHOR,CORE_UPDATE);
	new cfgDir[64];
	get_configsdir(cfgDir, 63);
	server_cmd("exec %s/%s.cfg",cfgDir,LUCKCORE);
	log_amx(CFGLOG,LUCKMSG,LUCKCORE);
	set_task(0.5,"get_settings");
}
// get settings from config file
public get_settings()
{
	addluck = get_pcvar_num(cvar_addluck);
	subluck = get_pcvar_num(cvar_subluck);
	addchance = get_pcvar_num(cvar_addchance);
	subchance = get_pcvar_num(cvar_subchance);
	addgood = get_pcvar_num(cvar_addgood);
	subgood = get_pcvar_num(cvar_subgood);
	addbad = get_pcvar_num(cvar_addbad);
	subbad = get_pcvar_num(cvar_subbad);
	riskcount = get_pcvar_num(cvar_addrisk);
	good_low = get_pcvar_num(goodlow);
	good_high = get_pcvar_num(goodhigh);
	goodlimit = get_pcvar_num(lucky);
	bad_low = get_pcvar_num(badlow);
	bad_high = get_pcvar_num(badhigh);
	badlimit = get_pcvar_num(unlucky);
	debugOn = get_pcvar_num(luckdebug);

	if(debugOn)
		log_cvars();
}
public log_cvars()
{
	if(addluck)
		log_amx(MSGLOG2, DEBUGMSG, ADDLUCK, IS_ON);
	if(subluck)
		log_amx(MSGLOG2, DEBUGMSG, SUBLUCK, IS_ON);
	if(addchance)
		log_amx(MSGLOG2, DEBUGMSG, ADDCHANCE, IS_ON);
	if(subchance)
		log_amx(MSGLOG2, DEBUGMSG, SUBCHANCE, IS_ON);
	if(addgood)
		log_amx(MSGLOG2, DEBUGMSG, ADDGOOD, IS_ON);
	if(subgood)
		log_amx(MSGLOG2, DEBUGMSG, SUBGOOD, IS_ON);
	if(addbad)
		log_amx(MSGLOG2, DEBUGMSG, ADDBAD, IS_ON);
	if(subbad)
		log_amx(MSGLOG2, DEBUGMSG, SUBBAD, IS_ON);
	if(good_low)
		log_amx(MSGLOG3, DEBUGMSG, GOODLOW, good_low);
	if(good_high)
		log_amx(MSGLOG3, DEBUGMSG, GOODHIGH, good_high);
	if(goodlimit)
		log_amx(MSGLOG3, DEBUGMSG, GOODLIMIT, goodlimit);
	if(bad_low)
		log_amx(MSGLOG3, DEBUGMSG, BADLOW, bad_low);
	if(bad_high)
		log_amx(MSGLOG3, DEBUGMSG, BADHIGH, bad_high);
	if(badlimit)
		log_amx(MSGLOG3, DEBUGMSG, BADLIMIT, badlimit);
	if(riskcount)
		log_amx(MSGLOG2, DEBUGMSG, RISKS, IS_ON);
}
// LUCK MOD NATIVES
// check if Luck Mod sub-plugins should debug - set to debug all plugins possible through 1 central function check
public _in_debug(plugin, params)
{
	if(params != 0)
		return PLUGIN_CONTINUE;

	if(!debugOn)
		return PLUGIN_CONTINUE;

	return PLUGIN_HANDLED
}
// check if player has loaded stats if using a database(?)
public _has_loaded(plugin, params)
{
	if(params != 1)
		return PLUGIN_CONTINUE;

	new id = get_param(1);

	if(!id)
		return PLUGIN_CONTINUE;

	if(!hasLoaded[id])
		return PLUGIN_CONTINUE;

	return PLUGIN_HANDLED
}
// set a player as "loaded"
public _set_loaded(plugin, params)
{
	if(params != 1)
		return PLUGIN_CONTINUE;

	new id = get_param(1);

	if(!id)
		return PLUGIN_CONTINUE;

	// player already loaded
	if(hasLoaded[id])
		return PLUGIN_CONTINUE;

	hasLoaded[id] = true;
	return PLUGIN_HANDLED
}
// add to user luck stats and chances if lucky, add good luck, remove bad luck
public _is_lucky(plugin, params)
{
	if(params != 1)
		return PLUGIN_CONTINUE;

	new id = get_param(1);

	if(!id)
		return PLUGIN_CONTINUE;

	if(addchance)
		chance[id]+=1;
	if(riskcount)
		risk[id]+=1;

	new goodrisk = random_num(good_low,good_high);

	if(goodrisk < goodlimit)
		return PLUGIN_CONTINUE;

	if(addluck)
		lucknum[id]+=1;
	if(addgood)
		goodluck[id]+=1;
	if(subbad)
		badluck[id]-=1;

	return PLUGIN_HANDLED
}
// remove from user luck stats and chances if unlucky, add bad luck, remove good luck
public _is_unlucky(plugin, params)
{
	if(params != 1)
		return PLUGIN_CONTINUE;

	new id = get_param(1);

	if(!id)
		return PLUGIN_CONTINUE;

	if(subchance)
		chance[id]-=1;
	if(riskcount)
		risk[id]+=1;

	new badrisk = random_num(bad_low,bad_high);

	if(badrisk > badlimit)
		return PLUGIN_CONTINUE;

	if(subluck)
		lucknum[id]-=1;
	if(addbad)
		badluck[id]+=1;
	if(subgood)
		goodluck[id]-=1;

	return PLUGIN_HANDLED;
}
// check if player has any luck stats
public _has_luck(plugin, params)
{
	if(params != 1)
		return PLUGIN_CONTINUE;

	new id = get_param(1);

	if(!id)
		return PLUGIN_CONTINUE;

	if(lucknum[id] < 1)
		return PLUGIN_CONTINUE;

	return PLUGIN_HANDLED
}
// check if player has any good luck
public _has_good_luck(plugin, params)
{
	if(params != 1)
		return PLUGIN_CONTINUE;

	new id = get_param(1);

	if(!id)
		return PLUGIN_CONTINUE;

	if(goodluck[id] < 1)
		return PLUGIN_CONTINUE;

	return PLUGIN_HANDLED
}
// check if player has any bad luck
public _has_bad_luck(plugin, params)
{
	if(params != 1)
		return PLUGIN_CONTINUE;

	new id = get_param(1);

	if(!id)
		return PLUGIN_CONTINUE;

	if(badluck[id] < 1)
		return PLUGIN_CONTINUE;

	return PLUGIN_HANDLED
}
// return value of player's luck stats
public _get_luck(plugin, params)
{
	if(params != 1)
		return PLUGIN_CONTINUE;

	new id = get_param(1);

	if(!id)
		return PLUGIN_CONTINUE;

	new get_value = lucknum[id];

	return get_value;
}
// return value of player's minimum luck
public _get_min_luck(plugin, params)
{
	if(params != 1)
		return PLUGIN_CONTINUE;

	new id = get_param(1);

	if(!id)
		return PLUGIN_CONTINUE;

	new minresult = minluck[id];

	return minresult;
}
// return value of player's maximum luck
public _get_max_luck(plugin, params)
{
	if(params != 1)
		return PLUGIN_CONTINUE;

	new id = get_param(1);

	if(!id)
		return PLUGIN_CONTINUE;

	new maxresult = maxluck[id];

	return maxresult;
}
// return value of player's good luck
public _get_good_luck(plugin, params)
{
	if(params != 1)
		return PLUGIN_CONTINUE;

	new id = get_param(1);

	if(!id)
		return PLUGIN_CONTINUE;

	new get_good = goodluck[id];

	return get_good;
}
// return value of player's minimum good luck
public _get_min_good(plugin, params)
{
	if(params != 1)
		return PLUGIN_CONTINUE;

	new id = get_param(1);

	if(!id)
		return PLUGIN_CONTINUE;

	new min_good = mingood[id];

	return min_good;
}
// return value of player's maximum good luck
public _get_max_good(plugin, params)
{
	if(params != 1)
		return PLUGIN_CONTINUE;

	new id = get_param(1);

	if(!id)
		return PLUGIN_CONTINUE;

	new max_good = maxgood[id];

	return max_good;
}
// return value of player's bad luck
public _get_bad_luck(plugin, params)
{
	if(params != 1)
		return PLUGIN_CONTINUE;

	new id = get_param(1);

	if(!id)
		return PLUGIN_CONTINUE;

	new get_bad = badluck[id];

	return get_bad;
}
// return value of player's minimum bad luck
public _get_min_bad(plugin, params)
{
	if(params != 1)
		return PLUGIN_CONTINUE;

	new id = get_param(1);

	if(!id)
		return PLUGIN_CONTINUE;

	new min_bad = minbad[id];

	return min_bad;
}
// return value of player's maximum bad luck
public _get_max_bad(plugin, params)
{
	if(params != 1)
		return PLUGIN_CONTINUE;

	new id = get_param(1);

	if(!id)
		return PLUGIN_CONTINUE;

	new max_bad = maxbad[id];

	return max_bad;
}
// sets user's luck stats to value
public _set_luck(plugin, params)
{
	if(params != 2)
		return PLUGIN_CONTINUE;

	new id = get_param(1);
	new value = get_param(2);

	if(!id || !value)
		return PLUGIN_CONTINUE;

	lucknum[id]=value;

	return PLUGIN_HANDLED;
}
// sets user's minimum luck stats to value
public _set_min_luck(plugin, params)
{
	if(params != 2)
		return PLUGIN_CONTINUE;

	new id = get_param(1);
	new value = get_param(2);

	if(!id || !value)
		return PLUGIN_CONTINUE;

	minluck[id]=value;

	return PLUGIN_HANDLED;
}
// sets user's maximum luck stats to value
public _set_max_luck(plugin, params)
{
	if(params != 2)
		return PLUGIN_CONTINUE;

	new id = get_param(1);
	new value = get_param(2);

	if(!id || !value)
		return PLUGIN_CONTINUE;

	maxluck[id]=value;

	return PLUGIN_HANDLED;
}
// sets user's good luck stats to value
public _set_good_luck(plugin, params)
{
	if(params != 2)
		return PLUGIN_CONTINUE;

	new id = get_param(1);
	new value = get_param(2);

	if(!id || !value)
		return PLUGIN_CONTINUE;

	goodluck[id]=value;

	return PLUGIN_HANDLED;
}
// sets user's minimum good luck stats to value
public _set_min_good(plugin, params)
{
	if(params != 2)
		return PLUGIN_CONTINUE;

	new id = get_param(1);
	new value = get_param(2);

	if(!id || !value)
		return PLUGIN_CONTINUE;

	mingood[id]=value;

	return PLUGIN_HANDLED;
}
// sets user's maximum good luck stats to value
public _set_max_good(plugin, params)
{
	if(params != 2)
		return PLUGIN_CONTINUE;

	new id = get_param(1);
	new value = get_param(2);

	if(!id || !value)
		return PLUGIN_CONTINUE;

	maxgood[id]=value;

	return PLUGIN_HANDLED;
}
// sets user's bad luck stats to value
public _set_bad_luck(plugin, params)
{
	if(params != 2)
		return PLUGIN_CONTINUE;

	new id = get_param(1);
	new value = get_param(2);

	if(!id || !value)
		return PLUGIN_CONTINUE;

	badluck[id]=value;

	return PLUGIN_HANDLED;
}
// sets user's minimum bad luck stats to value
public _set_min_bad(plugin, params)
{
	if(params != 2)
		return PLUGIN_CONTINUE;

	new id = get_param(1);
	new value = get_param(2);

	if(!id || !value)
		return PLUGIN_CONTINUE;

	minbad[id]=value;

	return PLUGIN_HANDLED;
}
// sets user's maximum bad luck stats to value
public _set_max_bad(plugin, params)
{
	if(params != 2)
		return PLUGIN_CONTINUE;

	new id = get_param(1);
	new value = get_param(2);

	if(!id || !value)
		return PLUGIN_CONTINUE;

	maxbad[id]=value;

	return PLUGIN_HANDLED;
}
// adds to user's luck stats
public _add_luck(plugin, params)
{
	if(params != 2)
		return PLUGIN_CONTINUE;

	new id = get_param(1);
	new value = get_param(2);

	if(!id || !value)
		return PLUGIN_CONTINUE;

	lucknum[id]+=value;

	return PLUGIN_HANDLED;
}
// adds to user's minimum luck stats
public _add_min_luck(plugin, params)
{
	if(params != 2)
		return PLUGIN_CONTINUE;

	new id = get_param(1);
	new value = get_param(2);

	if(!id || !value)
		return PLUGIN_CONTINUE;

	minluck[id]+=value;

	return PLUGIN_HANDLED;
}
// adds to user's maximum luck stats
public _add_max_luck(plugin, params)
{
	if(params != 2)
		return PLUGIN_CONTINUE;

	new id = get_param(1);
	new value = get_param(2);

	if(!id || !value)
		return PLUGIN_CONTINUE;

	maxluck[id]+=value;

	return PLUGIN_HANDLED;
}
// adds to user's good luck stats
public _add_good_luck(plugin, params)
{
	if(params != 2)
		return PLUGIN_CONTINUE;

	new id = get_param(1);
	new value = get_param(2);

	if(!id || !value)
		return PLUGIN_CONTINUE;

	goodluck[id]+=value;

	return PLUGIN_HANDLED;
}
// adds to user's minimum good luck stats
public _add_min_good(plugin, params)
{
	if(params != 2)
		return PLUGIN_CONTINUE;

	new id = get_param(1);
	new value = get_param(2);

	if(!id || !value)
		return PLUGIN_CONTINUE;

	mingood[id]+=value;

	return PLUGIN_HANDLED;
}
// adds to user's maximum good luck stats
public _add_max_good(plugin, params)
{
	if(params != 2)
		return PLUGIN_CONTINUE;

	new id = get_param(1);
	new value = get_param(2);

	if(!id || !value)
		return PLUGIN_CONTINUE;

	maxgood[id]+=value;

	return PLUGIN_HANDLED;
}
// adds to user's bad luck stats
public _add_bad_luck(plugin, params)
{
	if(params != 2)
		return PLUGIN_CONTINUE;

	new id = get_param(1);
	new value = get_param(2);

	if(!id || !value)
		return PLUGIN_CONTINUE;

	badluck[id]+=value;

	return PLUGIN_HANDLED;
}
// adds to user's minimum bad luck stats
public _add_min_bad(plugin, params)
{
	if(params != 2)
		return PLUGIN_CONTINUE;

	new id = get_param(1);
	new value = get_param(2);

	if(!id || !value)
		return PLUGIN_CONTINUE;

	minbad[id]+=value;

	return PLUGIN_HANDLED;
}
// adds to user's maximum bad luck stats
public _add_max_bad(plugin, params)
{
	if(params != 2)
		return PLUGIN_CONTINUE;

	new id = get_param(1);
	new value = get_param(2);

	if(!id || !value)
		return PLUGIN_CONTINUE;

	maxbad[id]+=value;

	return PLUGIN_HANDLED;
}
// subtracts from user's luck stats
public _sub_luck(plugin, params)
{
	if(params != 2)
		return PLUGIN_CONTINUE;

	new id = get_param(1);
	new value = get_param(2);

	if(!id || !value)
		return PLUGIN_CONTINUE;

	lucknum[id]-=value;

	return PLUGIN_HANDLED;	
}
// subtracts from user's minimum luck stats
public _sub_min_luck(plugin, params)
{
	if(params != 2)
		return PLUGIN_CONTINUE;

	new id = get_param(1);
	new value = get_param(2);

	if(!id || !value)
		return PLUGIN_CONTINUE;

	minluck[id]-=value;

	return PLUGIN_HANDLED;	
}
// subtracts from user's maximum luck stats
public _sub_max_luck(plugin, params)
{
	if(params != 2)
		return PLUGIN_CONTINUE;

	new id = get_param(1);
	new value = get_param(2);

	if(!id || !value)
		return PLUGIN_CONTINUE;

	maxluck[id]-=value;

	return PLUGIN_HANDLED;	
}
// subtracts from user's good luck stats
public _sub_good_luck(plugin, params)
{
	if(params != 2)
		return PLUGIN_CONTINUE;

	new id = get_param(1);
	new value = get_param(2);

	if(!id || !value)
		return PLUGIN_CONTINUE;

	goodluck[id]-=value;

	return PLUGIN_HANDLED;	
}
// subtracts from user's minimum good luck stats
public _sub_min_good(plugin, params)
{
	if(params != 2)
		return PLUGIN_CONTINUE;

	new id = get_param(1);
	new value = get_param(2);

	if(!id || !value)
		return PLUGIN_CONTINUE;

	mingood[id]-=value;

	return PLUGIN_HANDLED;	
}
// subtracts from user's maximum good luck stats
public _sub_max_good(plugin, params)
{
	if(params != 2)
		return PLUGIN_CONTINUE;

	new id = get_param(1);
	new value = get_param(2);

	if(!id || !value)
		return PLUGIN_CONTINUE;

	maxgood[id]-=value;

	return PLUGIN_HANDLED;	
}
// subtracts from user's bad luck stats
public _sub_bad_luck(plugin, params)
{
	if(params != 2)
		return PLUGIN_CONTINUE;

	new id = get_param(1);
	new value = get_param(2);

	if(!id || !value)
		return PLUGIN_CONTINUE;

	badluck[id]-=value;

	return PLUGIN_HANDLED;	
}
// subtracts from user's minimum bad luck stats
public _sub_min_bad(plugin, params)
{
	if(params != 2)
		return PLUGIN_CONTINUE;

	new id = get_param(1);
	new value = get_param(2);

	if(!id || !value)
		return PLUGIN_CONTINUE;

	minbad[id]-=value;

	return PLUGIN_HANDLED;	
}
// subtracts from user's maximum bad luck stats
public _sub_max_bad(plugin, params)
{
	if(params != 2)
		return PLUGIN_CONTINUE;

	new id = get_param(1);
	new value = get_param(2);

	if(!id || !value)
		return PLUGIN_CONTINUE;

	maxbad[id]-=value;

	return PLUGIN_HANDLED;	
}
// check if player has any chances
public _has_chance(plugin, params)
{
	if(params != 1)
		return PLUGIN_CONTINUE;

	new id = get_param(1);

	if(!id)
		return PLUGIN_CONTINUE;

	if(chance[id] < 1)
		return PLUGIN_CONTINUE;

	return PLUGIN_HANDLED
}
// get the number of chances a player has had to either have good luck or bad luck
public _get_chance(plugin, params)
{
	if(params != 1)
		return PLUGIN_CONTINUE;

	new id = get_param(1);

	if(!id)
		return PLUGIN_CONTINUE;

	new chances = chance[id];

	return chances;
}
// get the minimum number of chances a player has
public _get_min_chance(plugin, params)
{
	if(params != 1)
		return PLUGIN_CONTINUE;

	new id = get_param(1);

	if(!id)
		return PLUGIN_CONTINUE;

	new min_chance = minchance[id];

	return min_chance;
}
// get the maximum number of chances a player has
public _get_max_chance(plugin, params)
{
	if(params != 1)
		return PLUGIN_CONTINUE;

	new id = get_param(1);

	if(!id)
		return PLUGIN_CONTINUE;

	new max_chance = maxchance[id];

	return max_chance;
}
// set the number of chances a player has
public _set_chance(plugin, params)
{
	if(params != 2)
		return PLUGIN_CONTINUE;

	new id = get_param(1);
	new value = get_param(2);

	if(!id || !value)
		return PLUGIN_CONTINUE;

	chance[id]=value;

	return PLUGIN_HANDLED;	
}
// set the minimum number of chances a player has
public _set_min_chance(plugin, params)
{
	if(params != 2)
		return PLUGIN_CONTINUE;

	new id = get_param(1);
	new value = get_param(2);

	if(!id || !value)
		return PLUGIN_CONTINUE;

	minchance[id]=value;

	return PLUGIN_HANDLED;	
}
// set the maximum number of chances a player has
public _set_max_chance(plugin, params)
{
	if(params != 2)
		return PLUGIN_CONTINUE;

	new id = get_param(1);
	new value = get_param(2);

	if(!id || !value)
		return PLUGIN_CONTINUE;

	maxchance[id]=value;

	return PLUGIN_HANDLED;	
}
// add to chances a player has
public _add_chance(plugin, params)
{
	if(params != 2)
		return PLUGIN_CONTINUE;

	new id = get_param(1);
	new value = get_param(2);

	if(!id || !value)
		return PLUGIN_CONTINUE;

	chance[id]+=value;

	return PLUGIN_HANDLED;
}
// add to minimum chances a player has
public _add_min_chance(plugin, params)
{
	if(params != 2)
		return PLUGIN_CONTINUE;

	new id = get_param(1);
	new value = get_param(2);

	if(!id || !value)
		return PLUGIN_CONTINUE;

	minchance[id]+=value;

	return PLUGIN_HANDLED;
}
// add to maximum chances a player has
public _add_max_chance(plugin, params)
{
	if(params != 2)
		return PLUGIN_CONTINUE;

	new id = get_param(1);
	new value = get_param(2);

	if(!id || !value)
		return PLUGIN_CONTINUE;

	maxchance[id]+=value;

	return PLUGIN_HANDLED;
}
// subtract from chances a player has
public _sub_chance(plugin, params)
{
	if(params != 2)
		return PLUGIN_CONTINUE;

	new id = get_param(1);
	new value = get_param(2);

	if(!id || !value)
		return PLUGIN_CONTINUE;

	chance[id]-=value;

	return PLUGIN_HANDLED;	
}
// subtract from minimum chances a player has
public _sub_min_chance(plugin, params)
{
	if(params != 2)
		return PLUGIN_CONTINUE;

	new id = get_param(1);
	new value = get_param(2);

	if(!id || !value)
		return PLUGIN_CONTINUE;

	minchance[id]-=value;

	return PLUGIN_HANDLED;	
}
// subtract from maximum chances a player has
public _sub_max_chance(plugin, params)
{
	if(params != 2)
		return PLUGIN_CONTINUE;

	new id = get_param(1);
	new value = get_param(2);

	if(!id || !value)
		return PLUGIN_CONTINUE;

	maxchance[id]-=value;

	return PLUGIN_HANDLED;	
}
// check if player has any risk
public _has_risk(plugin, params)
{
	if(params != 1)
		return PLUGIN_CONTINUE;

	new id = get_param(1);

	if(!id)
		return PLUGIN_CONTINUE;

	if(chance[id] < 1)
		return PLUGIN_CONTINUE;

	return PLUGIN_HANDLED
}
// get the number of risks a player has had to either have good luck or bad luck
public _get_risk(plugin, params)
{
	if(params != 1)
		return PLUGIN_CONTINUE;

	new id = get_param(1);

	if(!id)
		return PLUGIN_CONTINUE;

	new risk_num = risk[id];

	return risk_num;
}
// get the minimum number of risks a player has
public _get_min_risk(plugin, params)
{
	if(params != 1)
		return PLUGIN_CONTINUE;

	new id = get_param(1);

	if(!id)
		return PLUGIN_CONTINUE;

	new min_risk = minrisk[id];

	return min_risk;
}
// get the maximum number of risks a player has
public _get_max_risk(plugin, params)
{
	if(params != 1)
		return PLUGIN_CONTINUE;

	new id = get_param(1);

	if(!id)
		return PLUGIN_CONTINUE;

	new max_risk = maxrisk[id];

	return max_risk;
}
// set the number of chances a player has
public _set_risk(plugin, params)
{
	if(params != 2)
		return PLUGIN_CONTINUE;

	new id = get_param(1);
	new value = get_param(2);

	if(!id || !value)
		return PLUGIN_CONTINUE;

	risk[id]=value;

	return PLUGIN_HANDLED;	
}
// set the minimum number of risks a player has
public _set_min_risk(plugin, params)
{
	if(params != 2)
		return PLUGIN_CONTINUE;

	new id = get_param(1);
	new value = get_param(2);

	if(!id || !value)
		return PLUGIN_CONTINUE;

	minrisk[id]=value;

	return PLUGIN_HANDLED;	
}
// set the maximum number of risks a player has
public _set_max_risk(plugin, params)
{
	if(params != 2)
		return PLUGIN_CONTINUE;

	new id = get_param(1);
	new value = get_param(2);

	if(!id || !value)
		return PLUGIN_CONTINUE;

	maxrisk[id]=value;

	return PLUGIN_HANDLED;	
}
// add to risks a player has
public _add_risk(plugin, params)
{
	if(params != 2)
		return PLUGIN_CONTINUE;

	new id = get_param(1);
	new value = get_param(2);

	if(!id || !value)
		return PLUGIN_CONTINUE;

	risk[id]+=value;

	return PLUGIN_HANDLED;
}
// add to minimum risks a player has
public _add_min_risk(plugin, params)
{
	if(params != 2)
		return PLUGIN_CONTINUE;

	new id = get_param(1);
	new value = get_param(2);

	if(!id || !value)
		return PLUGIN_CONTINUE;

	minrisk[id]+=value;

	return PLUGIN_HANDLED;
}
// add to maximum risks a player has
public _add_max_risk(plugin, params)
{
	if(params != 2)
		return PLUGIN_CONTINUE;

	new id = get_param(1);
	new value = get_param(2);

	if(!id || !value)
		return PLUGIN_CONTINUE;

	maxrisk[id]+=value;

	return PLUGIN_HANDLED;
}
// subtract from risks a player has
public _sub_risk(plugin, params)
{
	if(params != 2)
		return PLUGIN_CONTINUE;

	new id = get_param(1);
	new value = get_param(2);

	if(!id || !value)
		return PLUGIN_CONTINUE;

	risk[id]-=value;

	return PLUGIN_HANDLED;	
}
// subtract from minimum risks a player has
public _sub_min_risk(plugin, params)
{
	if(params != 2)
		return PLUGIN_CONTINUE;

	new id = get_param(1);
	new value = get_param(2);

	if(!id || !value)
		return PLUGIN_CONTINUE;

	minrisk[id]-=value;

	return PLUGIN_HANDLED;	
}
// subtract from maximum risks a player has
public _sub_max_risk(plugin, params)
{
	if(params != 2)
		return PLUGIN_CONTINUE;

	new id = get_param(1);
	new value = get_param(2);

	if(!id || !value)
		return PLUGIN_CONTINUE;

	maxrisk[id]-=value;

	return PLUGIN_HANDLED;	
}

public client_putinserver(id)
{
	hasLoaded[id] = false;
	lucknum[id] = 0;
	chance[id] = 0;
	goodluck[id] = 0;
	badluck[id] = 0;
	minluck[id] = 0;
	maxluck[id] = 0;
	minchance[id] = 0;
	maxchance[id] = 0;
	mingood[id] = 0;
	maxgood[id] = 0;
	minbad[id] = 0;
	maxbad[id] = 0;
	risk[id] = 0;
	minrisk[id] = 0;
	maxrisk[id] = 0;
	return PLUGIN_CONTINUE;
}

public client_disconnect(id)
{
	hasLoaded[id] = false;
	lucknum[id] = 0;
	chance[id] = 0;
	goodluck[id] = 0;
	badluck[id] = 0;
	minluck[id] = 0;
	maxluck[id] = 0;
	minchance[id] = 0;
	maxchance[id] = 0;
	mingood[id] = 0;
	maxgood[id] = 0;
	minbad[id] = 0;
	maxbad[id] = 0;
	risk[id] = 0;
	minrisk[id] = 0;
	maxrisk[id] = 0;
	return PLUGIN_CONTINUE;
}