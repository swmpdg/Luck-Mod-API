/*
August 18-19, 2016
Example AMXX Luck API plugin "Luck Stats + Health" by Swamp Dog
This is an example plugin for "Luck Mod" using the dynamic natives of the AMXX Luck API by Swamp Dog.
Credit for MySQL and File saving code used for "Luck Stats" in this plugin go to the author(s) of AMX Warn plugin: https://forums.alliedmods.net/showthread.php?p=57411?p=57411
I used the code from AMX Warn because it was easy to integrate into this example plugin. 
I recommend using a different method for MySQL saving, as DBI module may not be the best for this type of saving.
This is only an example plugin to demonstrate the natives of "AMXX Luck API" being used.
*/
#include <amxmodx>
#include <amxmisc>
#include <fun>
#include <luck>

// comment SAVE_STATS to turn off "Luck stats" saving system
#define SAVE_STATS

// comment USING_SQL to use file saving instead of MySQL saving
#define USING_SQL

// comment USING_SVEN to not use customized loading for Sven Co-op 5.0
#define USING_SVEN

#define VERSION "1.0"
#define AUTHOR "swampdog@modriot.com"
#define PLUGIN "Luck API Example Plugin"

#if defined SAVE_STATS

#if defined USING_SQL
#include <dbi>
#endif

new save_count[33];

#if defined USING_SQL
new Sql:dbc
new Result:result
#else
new filepath[251]
#endif
new savestats;
new luck_stat[33];
#endif
new debug_luck, luckloop;
new bool:isLoaded[33];

public plugin_init()
{
	register_plugin(PLUGIN, VERSION, AUTHOR);
	register_concmd("amx_setluck","set_player_luck", ADMIN_LEVEL_B,"Playername Value - Sets players luck to this value.");
	register_concmd("amx_addluck","add_player_luck", ADMIN_LEVEL_B,"Playername Value - Adds luck to player");
	register_concmd("amx_removeluck","remove_player_luck", ADMIN_LEVEL_B,"Playername Value - Removes luck from player");
	// for debug information and logging, set this to 1
	debug_luck = register_cvar("luck_debug","0");
	// set this cvar to 1 to run the luck loop, 0 to turn it off
	luckloop = register_cvar("luck_loop","1");
#if defined SAVE_STATS
	// to use saving for Luck stats
	savestats = register_cvar("luck_save","1");
#if !defined USING_SVEN
	if(get_pcvar_num(savestats))
	{
#if defined USING_SQL
		set_task(3.0,"sqlinit")
#else
		new directory[201]
		get_datadir(directory,200)
		format(filepath,251,"%s/luck.txt",directory)
		if(!file_exists(filepath))
		{
			new writestr[51]
			format(writestr,50,"Luck stats will be saved in here.")
			write_file(filepath,writestr)
		}
#endif
	}
#endif
#endif
}

public client_putinserver(id)
{
	isLoaded[id] = false;
#if defined SAVE_STATS
	save_count[id] = 0;
	if(get_pcvar_num(savestats))
	{
		luck_stat[id] = 0;
		new authid[35];
		get_user_authid(id,authid,34);
#if defined USING_SQL
		result = dbi_query(dbc,"SELECT * FROM luck_stats WHERE authid = '%s'",authid);
		if(result >= RESULT_OK)
		{
			dbi_nextrow(result);
			luck_stat[id] = dbi_result(result,"luck");
			new luckstat = luck_stat[id];
			set_luck(id, luckstat);
		}
		dbi_free_result(result);
#else
		new retstr[51], inum, a;
		while(read_file(filepath,inum,retstr,50,a) != 0)
		{
			new fid[35], warnlevel[2];
			parse(retstr,fid,34,warnlevel,1);
			if(equali(fid,authid))
			{
				luck_stat[id] = str_to_num(luck);
				new luckstat = luck_stat[id];
				set_luck(id, luckstat);
			}
			inum++;
		}
#endif
		if(luck_stat[id] > 0)
			client_print(id,print_chat,"You have %d Luck stats.",get_luck(id));
	}
#endif
	if(get_pcvar_num(luckloop))
		set_task(5.0, "luck_check", id, "", 0, "b");
	isLoaded[id] = true;
	return PLUGIN_HANDLED;
}

public luck_check(id)
{
	if(is_user_alive(id) && is_user_connected(id) && isLoaded[id])
	{
		new oldLuck = get_luck(id);
		// check if player is lucky with dynamic native from "AMXX Luck API"
		if(is_lucky(id))
		{
			if(get_user_health(id) < 645)
				set_user_health(id, get_user_health(id)+5);
			if (get_pcvar_num( debug_luck ) == 1 )
				client_print(id,print_chat,"You are lucky");
		}
		// check if player is unlucky with dynamic native from "AMXX Luck API"
		else if(is_unlucky(id))
		{
			if(get_user_health(id) > 5)
				set_user_health(id, get_user_health(id)-5);
			if (get_pcvar_num( debug_luck ) == 1 )
				client_print(id,print_chat,"You are unlucky");
		}
		else
		{
			if(get_pcvar_num(debug_luck) == 1)
				client_print(id,print_chat,"You are not lucky or unlucky.");
		}
		if (get_pcvar_num( debug_luck ) == 1 )
		{
			// check how much "Luck" a player has with dynamic native from "AMXX Luck API"
			new luckvalue = get_luck(id);
			client_print(id,print_chat,"Your current luck is %d.", luckvalue);
		}
#if defined SAVE_STATS
		if(get_luck(id) > oldLuck && get_pcvar_num(savestats))
		{
			if(save_count[id] > 5)
			{
				SaveLuck(id);
				save_count[id]=0;
			}
			else
				save_count[id]+=1;
		}
#endif			
	}
}
public set_player_luck( id, level, cid )
{
	if ( !cmd_access( id, ADMIN_LEVEL_B, cid, 3 ) || is_user_hltv(id) )
		return PLUGIN_HANDLED;
	
	new targetarg[32];
	read_argv(1, targetarg, 31);
	new target = cmd_target( id, targetarg, 11 );
	if ( !target )
		return PLUGIN_HANDLED;
	
	if(!isLoaded[target])
	{
		client_print(id, print_chat,"[LUCK MOD] Wait for player's stats to load.");
		return PLUGIN_HANDLED;
	}
	
	new luckarg[32];
	read_argv( 2, luckarg, 31 );
	new setluck = str_to_num( luckarg );
	
	// set luck of player to value with dynamic native from "AMXX Luck API"
	set_luck(target, setluck);
#if defined SAVE_STATS
	SaveLuck( target );
#endif
	if (get_pcvar_num( debug_luck ) == 1 )
	{
		new name[32];
		get_user_name( target, name, 31 );
		new adminname[32];
		new adminid[32];
		get_user_name( id, adminname, 31 );
		get_user_authid(id, adminid, 31 );
		log_amx("[LUCK MOD] %s %s set %s to %i Luck ",adminname, adminid, name, setluck );
		console_print( id, "%s now has %i Luck.", name, setluck);
	}
	return PLUGIN_HANDLED;
}
public add_player_luck( id, level, cid )
{
	if ( !cmd_access( id, ADMIN_LEVEL_B, cid, 3 ) || is_user_hltv(id) )
		return PLUGIN_HANDLED;
	
	new targetarg[32];
	read_argv(1, targetarg, 31);
	new target = cmd_target( id, targetarg, 11 );
	if ( !target )
		return PLUGIN_HANDLED;

	if(!isLoaded[target])
	{
		client_print(id, print_chat,"[LUCK MOD] Wait for player's stats to load.");
		return PLUGIN_HANDLED;
	}

	new luckarg[32];
	read_argv( 2, luckarg, 31 );
	new addluck = str_to_num( luckarg );
	if( !addluck )
		return PLUGIN_HANDLED;
	
	// add luck to player with dynamic native from "AMXX Luck API"
	add_luck(target, addluck);
#if defined SAVE_STATS
	SaveLuck( target );
#endif
	if (get_pcvar_num( debug_luck ) == 1 )
	{
		new name[32];
		get_user_name( target, name, 31 );
		new adminname[32];
		new adminid[32];
		get_user_name( id, adminname, 31 );
		get_user_authid(id, adminid, 31 );
		log_amx("[LUCK MOD] %s %s gave %s %i Luck ",adminname, adminid, name, addluck );
		console_print( id, "%s gained %i Luck. New Luck: %i", name, addluck, get_luck(target) );
	}
	return PLUGIN_HANDLED;
}
public remove_player_luck( id, level, cid )
{
	if ( !cmd_access( id, ADMIN_LEVEL_B, cid, 3 ) || is_user_hltv(id) )
		return PLUGIN_HANDLED;
	
	new targetarg[32];
	read_argv(1, targetarg, 31);
	new target = cmd_target( id, targetarg, 11 );
	if ( !target )
		return PLUGIN_HANDLED;

	if(!isLoaded[target])
	{
		client_print(id, print_chat,"[LUCK MOD] Wait for player's stats to load.");
		return PLUGIN_HANDLED;
	}

	new luckarg[32];
	read_argv( 2, luckarg, 31 );
	new subluck = str_to_num( luckarg );
	if( !subluck )
		return PLUGIN_HANDLED;
	
	// subtract luck from player with dynamic native from "AMXX Luck API"
	remove_luck(target, subluck);
#if defined SAVE_STATS
	SaveLuck( target );
#endif
	if (get_pcvar_num( debug_luck ) == 1 )
	{
		new name[32];
		get_user_name( target, name, 31 );
		new adminname[32];
		new adminid[32];
		get_user_name( id, adminname, 31 );
		get_user_authid(id, adminid, 31 );
		log_amx("[LUCK MOD] %s %s removed %s %i Luck ",adminname, adminid, name, subluck );
		console_print( id, "%s lost %i Luck. New Luck: %i", name, subluck, get_luck(target) );
	}
	return PLUGIN_HANDLED;
}
#if defined SAVE_STATS
#if defined USING_SVEN
public plugin_cfg()
{
#if defined USING_SQL
	set_task(3.0,"sqlinit");
#else
	new directory[201];
	get_datadir(directory,200);
	format(filepath,251,"%s/luck.txt",directory);
	if(!file_exists(filepath))
	{
		new writestr[51];
		format(writestr,50,"Luck stats will be saved in here.");
		write_file(filepath,writestr);
	}
#endif	
}
#endif
#if defined USING_SQL
public sqlinit()
{
	new error[32],sqlhostname[35],sqluser[35],sqlpass[35],sqldbname[35];
	
	get_cvar_string("amx_sql_host",sqlhostname,34);
	get_cvar_string("amx_sql_user",sqluser,34);
	get_cvar_string("amx_sql_pass",sqlpass,34);
	get_cvar_string("amx_sql_db",sqldbname,34);
	dbc = dbi_connect(sqlhostname,sqluser,sqlpass,sqldbname,error,31);
	
	if(dbc == SQL_FAILED)
	{
		server_print("[LUCK MOD] Could not connect to database.");
		return PLUGIN_HANDLED;
	}
	else
	{
		server_print("[LUCK MOD] Connected to database.");
	}
	
	result = dbi_query(dbc,"CREATE TABLE IF NOT EXISTS `luck_stats` (`authid` VARCHAR(35), `luck` INT(11) NOT NULL default '0')");
	dbi_free_result(result);
	return PLUGIN_HANDLED
}	
#endif
public SaveLuck(id)
{
	new authid[35];
	get_user_authid(id,authid,34);
	if(containi(authid,"ID_LAN") != -1)
#if defined USING_SQL
		result = dbi_query(dbc,"SELECT * FROM luck_stats WHERE authid = '%s'",authid);
		if(result >= RESULT_OK)
		{
			dbi_free_result(result);
			result = dbi_query(dbc,"UPDATE luck_stats SET luck = '%d' WHERE authid = '%s'",get_luck(id),authid);
		}
		else
		{
			dbi_free_result(result);
			result = dbi_query(dbc,"INSERT INTO luck_stats VALUES ( '%s' , '%d' )",authid,get_luck(id));
		}
		dbi_free_result(result);
#else
		new retstr[51], inum, a, bool:there = false, firstempty = -1;
		while(read_file(filepath,inum,retstr,50,a) != 0)
		{
			if(strlen(retstr) <= 0) firstempty = inum;
			new fid[35], luck[2];
			parse(retstr,fid,34,luck,1);
			new lucknum = str_to_num(luck);
			if(equali(fid,authid))
			{
				there = true;
				lucknum++;
				new newluck[2];
				num_to_str(lucknum,newluck,1);
				replace(retstr,50,luck,newluck);
				write_file(filepath,retstr,inum);
			}
			inum++;
		}
		if(!there)
		{
			new writestr[51];
			format(writestr,50,"%s %d",authid,get_luck(id));
			write_file(filepath,writestr,firstempty);
		}
#endif
	return PLUGIN_HANDLED;
}
#endif