-- Set your session 

!set variable_substitution=true

-- You can also define defaults here, they'll be overridden by -D flags.
-- !define ROLE=SYSADMIN
-- !define WAREHOUSE=COMPUTE_WH
-- !define DB=AGS_GAME_AUDIENCE

USE ROLE IDENTIFIER('&ROLE');
USE WAREHOUSE IDENTIFIER('&WAREHOUSE');
CREATE DATABASE IF NOT EXISTS IDENTIFIER('&DB');
