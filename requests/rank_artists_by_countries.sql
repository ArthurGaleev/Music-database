SELECT ( SELECT countries.name FROM Countries 
         WHERE countries.id = country_id ) AS country, 
       name,
       popularity, 
       rank() OVER ( PARTITION BY country_id 
                     ORDER BY popularity DESC ) AS country_rank
FROM Artists
ORDER BY 1, 4, 2;