SELECT a.name AS artist,
       s.name AS song,
       COUNT ( * ) likes,
       s.popularity num_of_plays
FROM Liked_songs ls
JOIN Songs s ON s.id = ls.id
JOIN Artists a ON a.id = s.id
JOIN Countries c ON c.id = a.id AND c.name = 'Denmark'
GROUP BY 1, 2, 4
ORDER BY 1, 2, 3, 4;