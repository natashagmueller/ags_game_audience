create or replace task AGS_GAME_AUDIENCE.RAW.CDC_LOAD_LOGS_ENHANCED
	schedule='5 minutes'
	USER_TASK_MANAGED_INITIAL_WAREHOUSE_SIZE='XSMALL'
	when system$stream_has_data('ed_cdc_stream')
	as MERGE INTO AGS_GAME_AUDIENCE.ENHANCED.LOGS_ENHANCED e
        USING (
                SELECT cdc.ip_address 
                , cdc.user_login as GAMER_NAME
                , cdc.user_event as GAME_EVENT_NAME
                , cdc.datetime_iso8601 as GAME_EVENT_UTC
                , city
                , region
                , country
                , timezone as GAMER_LTZ_NAME
                , CONVERT_TIMEZONE( 'UTC',timezone,cdc.datetime_iso8601) as game_event_ltz
                , DAYNAME(game_event_ltz) as DOW_NAME
                , TOD_NAME
                from ags_game_audience.raw.ed_cdc_stream cdc
                JOIN ipinfo_geoloc.demo.location loc 
                ON ipinfo_geoloc.public.TO_JOIN_KEY(cdc.ip_address) = loc.join_key
                AND ipinfo_geoloc.public.TO_INT(cdc.ip_address) 
                BETWEEN start_ip_int AND end_ip_int
                JOIN AGS_GAME_AUDIENCE.RAW.TIME_OF_DAY_LU tod
                ON HOUR(game_event_ltz) = tod.hour
              ) r
        ON r.GAMER_NAME = e.GAMER_NAME
        AND r.GAME_EVENT_UTC = e.GAME_EVENT_UTC
        AND r.GAME_EVENT_NAME = e.GAME_EVENT_NAME 
        WHEN NOT MATCHED THEN 
        INSERT (IP_ADDRESS, GAMER_NAME, GAME_EVENT_NAME
                , GAME_EVENT_UTC, CITY, REGION
                , COUNTRY, GAMER_LTZ_NAME, GAME_EVENT_LTZ
                , DOW_NAME, TOD_NAME)
                VALUES
                (IP_ADDRESS, GAMER_NAME, GAME_EVENT_NAME
                , GAME_EVENT_UTC, CITY, REGION
                , COUNTRY, GAMER_LTZ_NAME, GAME_EVENT_LTZ
                , DOW_NAME, TOD_NAME);
