USE ROLE ACCOUNTADMIN;
CREATE OR REPLACE DATABASE spotify_db;
CREATE OR REPLACE SCHEMA spotify_db.raw;

CREATE OR REPLACE TABLE spotify_db.raw.song (
    song_id STRING,
    song_name STRING,
    song_duration NUMBER,
    song_popularity NUMBER,
    song_added TIMESTAMP,
    song_album_id STRING,
    song_artist_id STRING
);

CREATE OR REPLACE TABLE spotify_db.raw.artist (
    artist_id STRING,
    artist_name STRING,
    artist_url STRING
);

CREATE OR REPLACE TABLE spotify_db.raw.album (
    album_id STRING,
    album_name STRING,
    album_release_date DATE,
    album_url STRING,
    album_track NUMBER
);

CREATE OR REPLACE STORAGE INTEGRATION spotify_s3_integration
TYPE = EXTERNAL_STAGE
STORAGE_PROVIDER = S3
ENABLED = TRUE
STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::YOUR_ACCOUNT_ID:role/snowflake_s3_role'
STORAGE_ALLOWED_LOCATIONS = ('s3://YOUR_BUCKET_NAME/');

CREATE OR REPLACE STAGE spotify_stage
URL = 's3://YOUR_BUCKET_NAME/transformed_data/'
STORAGE_INTEGRATION = spotify_s3_integration;

CREATE OR REPLACE FILE FORMAT csv_format
TYPE = CSV
FIELD_OPTIONALLY_ENCLOSED_BY = '"'
SKIP_HEADER = 1;

CREATE OR REPLACE PIPE song_pipe
AUTO_INGEST = TRUE
AS
COPY INTO spotify_db.raw.song
FROM @spotify_stage/song_data/
FILE_FORMAT = csv_format;

CREATE OR REPLACE PIPE artist_pipe
AUTO_INGEST = TRUE
AS
COPY INTO spotify_db.raw.artist
FROM @spotify_stage/artist_data/
FILE_FORMAT = csv_format;

CREATE OR REPLACE PIPE album_pipe
AUTO_INGEST = TRUE
AS
COPY INTO spotify_db.raw.album
FROM @spotify_stage/album_data/
FILE_FORMAT = csv_format;