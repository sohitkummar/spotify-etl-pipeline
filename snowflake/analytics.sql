CREATE OR REPLACE SCHEMA spotify_db.analytics;

CREATE OR REPLACE VIEW spotify_db.analytics.top_songs AS
SELECT DISTINCT
    s.song_name,
    a.artist_name,
    s.song_popularity,
    ROUND(s.song_duration / 60000.0, 2) AS duration_minutes
FROM spotify_db.raw.song s
JOIN spotify_db.raw.artist a ON s.song_artist_id = a.artist_id
ORDER BY s.song_popularity DESC
LIMIT 10;

CREATE OR REPLACE VIEW spotify_db.analytics.artist_song_count AS
SELECT
    a.artist_name,
    COUNT(s.song_id) AS total_songs,
    ROUND(AVG(s.song_popularity), 2) AS avg_popularity
FROM spotify_db.raw.song s
JOIN spotify_db.raw.artist a ON s.song_artist_id = a.artist_id
GROUP BY a.artist_name
ORDER BY total_songs DESC;

CREATE OR REPLACE VIEW spotify_db.analytics.album_timeline AS
SELECT
    al.album_name,
    al.album_release_date,
    al.album_track,
    COUNT(s.song_id) AS songs_in_playlist
FROM spotify_db.raw.album al
JOIN spotify_db.raw.song s ON s.song_album_id = al.album_id
GROUP BY al.album_name, al.album_release_date, al.album_track
ORDER BY al.album_release_date DESC;