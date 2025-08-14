-- Requires ACCOUNTADMIN to run
-- Replace the {{...}} placeholders before running (or via your CI)
CREATE OR REPLACE STORAGE INTEGRATION {{aws_int_name}}
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = S3
  ENABLED = TRUE
  STORAGE_AWS_ROLE_ARN = '{{aws_role_arn}}'                    -- e.g. arn:aws:iam::<acct>:role/snowflake-stage-role
  STORAGE_ALLOWED_LOCATIONS = ('s3://{{bucket}}/{{prefix}}/')  -- narrow to your path
  COMMENT = 'Portfolio demo integration game audience';

-- After creating, run this (not committed) to fetch values you need for the AWS trust policy:
-- DESC INTEGRATION {{aws_int_name}};
-- Look for STORAGE_AWS_IAM_USER_ARN and STORAGE_AWS_EXTERNAL_ID and configure your AWS role trust.
