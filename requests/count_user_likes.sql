WITH user_likes 
AS ( 
     SELECT u.name 
     FROM Users u 
     JOIN Liked_songs ls ON u.id = ls.user_id 
     GROUP BY u.id, ls.id
   ) 
SELECT ul.name, 
       COUNT ( * ) 
  FROM User_likes as ul 
  GROUP BY ul.name
  ORDER BY 2 DESC, 1;