SELECT art_c.art_name AS artist,
       s.name AS song,
       alb.name AS album,
       g.name AS genre,
       art_c.c_name AS country
FROM Songs s
JOIN ( SELECT art.id, 
              art.name AS art_name, 
              c.name AS c_name 
       FROM Artists art Join Countries c ON c.id = art.country_id 
     ) art_c ON art_c.id = s.artist_id
JOIN Albums alb ON alb.id = s.album_id
JOIN Genres g ON g.id = s.genre_id
ORDER BY 1, 2, 3, 4;