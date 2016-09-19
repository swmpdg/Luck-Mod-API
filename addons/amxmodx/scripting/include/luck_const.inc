/*
"luck_const.inc"
Originally created September 18, 2016
Last updated September 19, 2016
AMXX Luck API core plugin constants by Swamp Dog @ ModRiot.com
This file can be used across multiple plugins to load constant data.
Some of these implementations of constants will be moved to a dictionary file or elsewhere.
*/

#if defined _luckconst_included
  #endinput
#endif
#define _luckconst_included

#define LUCK_SLOTS 32

stock const CORE_NAME[] = "Luck Mod Core";
stock const CORE_UPDATE[] = "19 September 2016";
stock const CORE_VERSION[] = "1.1.0";
stock const CORE_AUTHOR[] = "swampdog@modriot.com";
stock const LUCKCORE[] = "luck";
stock const LUCKMSG[] = "[LUCK]";
stock const DEBUGMSG[] = "[LUCK DEBUG]";
stock const MSGLOG[] = "%s Loading %s %s, by %s, last updated %s";
stock const MSGLOG2[] = "%s %s %s";
stock const MSGLOG3[] = "%s %s is %i";
stock const IS_ON[] = "is enabled";
stock const ADDLUCK[] = "add_luck";
stock const SUBLUCK[] = "sub_luck";
stock const ADDCHANCE[] = "add_chance";
stock const SUBCHANCE[] = "sub_chance"
stock const ADDGOOD[] = "add_goodluck"
stock const SUBGOOD[] = "sub_goodluck"
stock const ADDBAD[] = "add_badluck"
stock const SUBBAD[] = "sub_badluck"
stock const GOODLOW[] = "goodluck_low"
stock const GOODHIGH[] = "goodluck_high"
stock const GOODLIMIT[] = "lucky_limit"
stock const BADLOW[] = "badluck_low"
stock const BADHIGH[] = "badluck_high"
stock const BADLIMIT[] = "unlucky_limit"
stock const RISKS[] = "risk_count"
stock const DEBUGON[] = "luck_debug"