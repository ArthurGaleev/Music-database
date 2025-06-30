SELECT u.name AS user_name, 
       up.name AS playlist_name, 
       up.private, 
       up.song_ids, 
       up.popularity 
FROM User_playlists up 
JOIN Users u ON up.user_id = u.id 
ORDER BY 1, 2;