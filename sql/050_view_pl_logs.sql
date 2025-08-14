create or replace view AGS_GAME_AUDIENCE.RAW.PL_LOGS(
	IP_ADDRESS,
	USER_EVENT,
	USER_LOGIN,
	DATETIME_ISO8601,
	RAW_LOG
) as 
select 
RAW_LOG:ip_address::text as IP_ADDRESS,
RAW_LOG:user_event::text as USER_EVENT,
RAW_LOG:user_login::text as USER_LOGIN,
RAW_LOG:datetime_iso8601::TIMESTAMP_NTZ as DATETIME_ISO8601, 
*
FROM pl_game_logs
WHERE RAW_LOG:agent is null;
