SELECT a.name AS artist,
       s.name AS song,
       COUNT ( * ) likes,
       s.popularity num_of_plays
FROM Liked_songs ls
JOIN Songs s ON s.artist_id = ls.song_id
JOIN Artists a ON a.id = s.artist_id
JOIN Countries c ON c.id = a.country_id AND c.name = 'USA'
GROUP BY 1, 2, 4
ORDER BY 3 DESC, 4 DESC, 1 DESC, 2 DESC;
