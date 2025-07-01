-- ----------------------------------------------------------------------------
-- База данных для приложения с оцифрованной музыкой
-- ----------------------------------------------------------------------------

-- ----------------------------------------------------------------------------
-- Таблица "Страны"
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS Countries CASCADE;

CREATE TABLE Countries
( id SMALLINT NOT NULL PRIMARY KEY,  -- уникальный номер страны
  name VARCHAR( 64 ) NOT NULL        -- название страны
);

-- Первоначальное заполнение таблицы
INSERT INTO Countries VALUES
( 0, 'USA'),
( 1, 'Australia'),
( 2, 'Denmark');


-- ----------------------------------------------------------------------------
-- Таблица "Музыкальные исполнители"
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS Artists CASCADE;

CREATE TABLE Artists
( id BIGINT NULL PRIMARY KEY,    -- уникальный номер исполнителя
  name VARCHAR( 64 ) NOT NULL,   -- имя исполнителя
  country_id SMALLINT NOT NULL,  -- уникальный номер страны исполнителя
  popularity BIGINT DEFAULT 0,   -- кол-во прослушиваний

  FOREIGN KEY ( country_id )     -- country_id - внешний ключ
    REFERENCES Countries ( id )
    ON DELETE CASCADE            -- если страна исполнителя удалена, то можно удалять и его самого
    ON UPDATE CASCADE            -- если изменен номер страны, то здесь его нужно так же изменить
);

-- Первоначальное заполнение таблицы
INSERT INTO Artists VALUES
( 0, 'RHCP', 0 ),
( 1, 'Metallica', 0 ),
( 2, 'Chris Cornell', 1 ),
( 3, 'Don Mclean', 2 );


-- ----------------------------------------------------------------------------
-- Таблица "Альбомы"
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS Albums CASCADE;

CREATE TABLE Albums
( id BIGINT NOT NULL PRIMARY KEY,       -- уникальный номер альбома
  name VARCHAR( 64 ) NOT NULL,          -- название альбома
  artist_id BIGINT NOT NULL,            -- уникальный номер исполнителя
  song_ids BIGINT[],                    -- массив уникальных номеров песен
  popularity BIGINT DEFAULT 0 NOT NULL, -- кол-во прослушиваний
  
  FOREIGN KEY ( artist_id )             -- artist_id - внешний ключ
    REFERENCES ARTISTS ( id )
    ON DELETE CASCADE                   -- если исполнитель удален, то можно удалять и его альбом
    ON UPDATE CASCADE                   -- если изменен номер исполнителя, то здесь его нужно так же изменить
);

-- Первоначальное заполнение таблицы
INSERT INTO Albums VALUES
( 0, 'The Getaway', 0 ),
( 1, 'Stadium Arcadium', 0 ),
( 2, 'Ride the Lightning', 1 ),
( 3, 'Master of Puppets', 1 ),
( 4, 'Higher Truth', 2 ),
( 5, 'American Pie', 3 );


-- ----------------------------------------------------------------------------
-- Таблица "Пользователи"
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS Users CASCADE;

CREATE TABLE Users
( id BIGINT NOT NULL PRIMARY KEY,  -- уникальный номер пользователя
  name VARCHAR( 64 ) NOT NULL,     -- имя пользователя
  country_id SMALLINT NOT NULL,    -- уникальный номер страны
  song_ids_history BIGINT[],       -- массив уникальных номеров прослушанных песен
  playlist_ids_history BIGINT[],   -- массив уникальных номеров прослушанных плейлистов

  Unique ( name ),                 -- уникальность имени

  FOREIGN KEY ( country_id )       -- country_id - внешний ключ
    REFERENCES Countries ( id )
    ON DELETE CASCADE              -- если страна пользователя удалена, то можно удалять и ее его самого
    ON UPDATE CASCADE              -- если изменен номер страны, то здесь его нужно так же изменить
);

-- Первоначальное заполнение таблицы
INSERT INTO Users VALUES
( 0, 'Ваня', 1 ),
( 1, 'Паша', 1 ),
( 2, 'Алексей', 1 ),
( 3, 'Стас', 0 ),
( 4, 'Николай', 2 ),
( 5, 'Андрей', 0 );


-- ----------------------------------------------------------------------------
-- Таблица "Плейлисты пользователей"
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS User_playlists CASCADE;

CREATE TABLE User_playlists
( id BIGINT NOT NULL PRIMARY KEY,         -- уникальный номер плейлиста пользователя
  name VARCHAR( 64 ) NOT NULL,            -- название плейлиста
  private BOOLEAN DEFAULT TRUE NOT NULL,  -- приватный ли плейлист
  user_id BIGINT NOT NULL,                -- уникальный номер пользователя
  song_ids BIGINT[],                      -- массив уникальных номеров песен
  popularity BIGINT DEFAULT 0 NOT NULL,   -- кол-во прослушиваний

  Unique ( name ),                        -- уникальность названия плейлиста

  FOREIGN KEY ( user_id )                 -- user_id - внешний ключ
    REFERENCES Users ( id )
    ON DELETE CASCADE                     -- если пользователь удален, то можно удалять и его плейлисты
    ON UPDATE CASCADE                     -- если изменен номер пользователя, то здесь его нужно так же изменить
);

-- Первоначальное заполнение таблицы
INSERT INTO User_playlists VALUES
( 0, 'For the weekend', FALSE, 3, ARRAY[3, 4, 6, 9]),
( 1, 'To chill', TRUE, 1, ARRAY[1, 3, 4, 7, 9]),
( 2, 'Nostalgia', FALSE, 5, ARRAY[0, 1, 5]);


-- ----------------------------------------------------------------------------
-- Таблица "Жанры"
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS Genres CASCADE;

CREATE TABLE Genres
( id SMALLINT NOT NULL PRIMARY KEY,     -- уникальный номер жанра
  name VARCHAR( 64 ) NOT NULL,          -- название жанра
  popularity BIGINT DEFAULT 0 NOT NULL  -- кол-во прослушиваний
);

-- Первоначальное заполнение таблицы
INSERT INTO Genres VALUES
( 0, 'Alternative rock' ),
( 1, 'Metal' ),
( 2, 'Country' );


-- ----------------------------------------------------------------------------
-- Таблица "Песни"
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS Songs CASCADE;

CREATE TABLE Songs
( id BIGINT NOT NULL PRIMARY KEY,        -- уникальный номер песни
  name VARCHAR( 64 ) NOT NULL,           -- название песни
  artist_id BIGINT NOT NULL,             -- уникальный номер исполнителя
  album_id BIGINT NOT NULL,              -- уникальный номер альбома
  genre_id SMALLINT NOT NULL,            -- уникальный номер жанра
  popularity BIGINT DEFAULT 0 NOT NULL,  -- кол-во прослушиваний

  Unique ( name ),                       -- уникальность названия песни

  FOREIGN KEY ( artist_id )              -- artist_id - внешний ключ
    REFERENCES Artists ( id )
    ON DELETE CASCADE                    -- если артист песни удален, то можно удалять и ее саму
    ON UPDATE CASCADE,                   -- если изменен номер артиста, то здесь его нужно так же изменить
  
  FOREIGN KEY ( album_id )               -- album_id - внешний ключ
    REFERENCES Albums ( id )
    ON DELETE CASCADE                    -- если альбом песни удален, то можно удалять и ее саму
    ON UPDATE CASCADE,                   -- если изменен номер альбома, то здесь его нужно так же изменить
  
  FOREIGN KEY ( genre_id )               -- genre_id - внешний ключ
    REFERENCES Genres ( id )
    ON DELETE CASCADE                    -- если жанр песни удален, то можно удалять и ее саму
    ON UPDATE CASCADE                    -- если изменен номер жанра, то здесь его нужно так же изменить
);

-- Первоначальное заполнение таблицы
INSERT INTO Songs VALUES
( 0, 'Fade to Black', 1, 2, 1 ),
( 1, 'Vincent', 3, 5, 2 ),
( 2, 'Before We Disappear', 2, 4, 0 ),
( 3, 'Scar Tissue', 0, 1, 0 ),
( 4, 'Snow', 0, 1, 0 ),
( 5, 'Empty Chairs', 3, 5, 2 ),
( 6, 'Go Robot', 0, 0, 0 ),
( 7, 'Dark Necessities', 0, 0, 0 ),
( 8, 'Enter The Sandman', 1, 3, 1 ),
( 9, 'Slow Cheetah', 0, 1, 0 );


-- ----------------------------------------------------------------------------
-- Таблица "Понравившиеся песни"
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS Liked_songs CASCADE;

CREATE TABLE Liked_songs
( id BIGINT NOT NULL PRIMARY KEY,  -- уникальный номер отметки 'лайк песни'
  user_id BIGINT NOT NULL,         -- уникальный номер пользователя
  song_id BIGINT NOT NULL,         -- уникальный номер песни

  FOREIGN KEY ( user_id )          -- user_id - внешний ключ
    REFERENCES Users ( id )
    ON DELETE CASCADE              -- если пользователь удален, то можно удалять и его плейлисты
    ON UPDATE CASCADE              -- если изменен номер пользователя, то здесь его нужно так же изменить
);

-- Первоначальное заполнение таблицы
INSERT INTO Liked_songs VALUES
( 0, 2, 3),
( 1, 0, 5),
( 2, 0, 9),
( 3, 2, 9),
( 4, 3, 9),
( 5, 1, 1),
( 6, 1, 0),
( 7, 2, 6),
( 8, 3, 4),
( 9, 1, 9),
( 10, 0, 7),
( 11, 3, 7),
( 12, 1, 3),
( 13, 1, 5),
( 14, 3, 2),
( 15, 2, 3),
( 16, 3, 8),
( 17, 1, 4),
( 18, 1, 9),
( 19, 1, 9),
( 20, 1, 0),
( 21, 1, 0),
( 22, 3, 8);


-- ----------------------------------------------------------------------------
-- Триггер для увеличения кол-ва прослушиваний композиций (увеличение популярности)
-- ----------------------------------------------------------------------------

-- функция, которая увеличивает на 1 популярность всех
-- элементов музыкальной композиции: песни, исполнителя, альбома, жанра
CREATE OR REPLACE FUNCTION update_composition_popularity() RETURNS trigger AS
$$
DECLARE
-- переменная только что прослушанной песни 
-- (для ускорения, так как нужно воспользоваться несколько раз)
  last_song_id BIGINT;
BEGIN
  last_song_id := NEW.song_ids_history[ARRAY_LENGTH( NEW.song_ids_history, 1 )];

  -- инкрементируем популярность прослушанной песни
  UPDATE Songs
    SET popularity = popularity + 1
  WHERE Songs.id = last_song_id;
    
  -- инкрементируем популярность прослушанного артиста
  UPDATE Artists
    SET popularity = popularity + 1
  WHERE Artists.id = ( SELECT artist_id FROM Songs WHERE Songs.id = last_song_id );

  -- инкрементируем популярность прослушанного альбома
  UPDATE Albums
    SET popularity = popularity + 1
  WHERE Albums.id = ( SELECT album_id FROM Songs WHERE Songs.id = last_song_id );

  -- инкрементируем популярность прослушанного жанра
  UPDATE Genres
    SET popularity = popularity + 1
  WHERE Genres.id = ( SELECT genre_id FROM Songs WHERE Songs.id = last_song_id );
  
  RETURN NEW;
END;
$$
LANGUAGE plpgsql;

-- триггер, который следит за новыми прослушиваниями композиций, увеличивая популярность композций
DROP TRIGGER IF EXISTS song_listened ON Users;

CREATE TRIGGER song_listened
AFTER UPDATE OF song_ids_history ON Users
  FOR EACH ROW EXECUTE PROCEDURE update_composition_popularity();


-- ----------------------------------------------------------------------------
-- Триггер для увеличения кол-ва прослушиваний плейлистов (увеличение популярности)
-- ----------------------------------------------------------------------------

-- функция, аналогичная update_composition_popularity(), 
-- которая увеличивает на 1 популярность плейлиста
CREATE OR REPLACE FUNCTION update_playlist_popularity() RETURNS trigger AS
$$
-- здесь, в отличие от update_composition_popularity можно 
-- без переменной, так как она требуется только в одном месте
BEGIN
  -- инкрементируем популярность прослушанного плейлиста
  UPDATE User_playlists
    SET popularity = popularity + 1
  WHERE User_playlists.id = NEW.playlist_ids_history[ARRAY_LENGTH( NEW.playlist_ids_history, 1 )];
  
  RETURN NEW;
END;
$$
LANGUAGE plpgsql;

-- триггер, который следит за новыми прослушиваниями плейлистов, увеличивая популярность композций
DROP TRIGGER IF EXISTS playlist_listened ON Users;

CREATE TRIGGER playlist_listened
AFTER UPDATE OF playlist_ids_history ON Users
  FOR EACH ROW EXECUTE PROCEDURE update_playlist_popularity();


-- ----------------------------------------------------------------------------
-- Функция прослушивания пользователем песни
-- ----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION listen_song( IN user_id BIGINT, IN song_id BIGINT )
  RETURNS VOID AS
$$
BEGIN
  UPDATE Users
    SET song_ids_history = array_append(song_ids_history, song_id)
  WHERE id = user_id;
END;
$$
LANGUAGE plpgsql;

-- Первоначальное добавление прослушиваний песен
SELECT listen_song ( 0, 2 );
SELECT listen_song ( 0, 3 );
SELECT listen_song ( 0, 4 );
SELECT listen_song ( 0, 7 );
SELECT listen_song ( 1, 1 );
SELECT listen_song ( 1, 4 );
SELECT listen_song ( 1, 5 );
SELECT listen_song ( 1, 9 );
SELECT listen_song ( 2, 2 );
SELECT listen_song ( 2, 3 );
SELECT listen_song ( 2, 5 );
SELECT listen_song ( 2, 6 );
SELECT listen_song ( 2, 9 );
SELECT listen_song ( 3, 5 );
SELECT listen_song ( 3, 6 );
SELECT listen_song ( 3, 7 );
SELECT listen_song ( 3, 8 );
SELECT listen_song ( 3, 9 );
SELECT listen_song ( 5, 3 );
SELECT listen_song ( 5, 4 );
SELECT listen_song ( 5, 5 );
SELECT listen_song ( 5, 6 );
SELECT listen_song ( 5, 7 );
SELECT listen_song ( 5, 9 );

-- ----------------------------------------------------------------------------
-- Функция прослушивания пользователем плейлиста
-- ----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION listen_playlist( IN user_id BIGINT, IN playlist_id BIGINT )
  RETURNS VOID AS
$$
BEGIN
  IF ( SELECT private FROM User_playlists WHERE id = playlist_id )
  THEN
    RAISE EXCEPTION 'This playlist is for private use only';
  END IF;

  UPDATE Users
    SET playlist_ids_history = ARRAY_APPEND(playlist_ids_history, playlist_id)
  WHERE id = user_id;
END;
$$
LANGUAGE plpgsql;

-- Первоначальное добавление прослушиваний пплейлистов
SELECT listen_playlist ( 0, 0);
SELECT listen_playlist ( 0, 2);
SELECT listen_playlist ( 1, 0);
SELECT listen_playlist ( 2, 0);
SELECT listen_playlist ( 3, 2);
SELECT listen_playlist ( 5, 0);


-- ----------------------------------------------------------------------------
-- Функция добавления плейлиста
-- ----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION create_playlist( IN name VARCHAR( 64 ), IN private BOOLEAN, IN user_id BIGINT, IN song_ids BIGINT[] )
  RETURNS VOID AS
$$
DECLARE
-- переменная для нового индекса плейлиста
  new_id BIGINT;
BEGIN
-- проверяем, что таблица не пустая (LIMIT, чтобы быстрее работало)
-- и выбираем новый уникальный индекс плейлиста, например - максимум плюс 1
  if EXISTS ( SELECT * FROM User_playlists LIMIT 1 )
  THEN
    new_id := MAX( ( SELECT id FROM User_playlists ) ) + 1;
  ELSE
    new_id := 0;
  END IF;

  INSERT INTO User_playlists VALUES
  ( new_id, name, private, user_id, song_ids );

-- мы его создали, мы его первый слушатель
-- PERFORM, так как нам не нужен результат SELECT (psql сам подсказал)
  PERFORM listen_playlist( user_id, new_id ); 

END;
$$
LANGUAGE plpgsql;


-- ----------------------------------------------------------------------------
-- Функция для добавления лайка к песне
-- ----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION like_song( IN user_id BIGINT, IN song_id BIGINT )
  RETURNS VOID AS
$$
DECLARE
-- переменная для нового индекса лайка для песни
  new_id BIGINT;
BEGIN
  -- проверяем, что таблица не пустая (LIMIT, чтобы быстрее работало)
  -- и выбираем новый уникальный индекс лайка для песни, например - максимум плюс 1
  if EXISTS ( SELECT * FROM Liked_songs LIMIT 1 )
  THEN
    new_id := MAX( ( SELECT id FROM Liked_songs ) ) + 1;
  ELSE
    new_id := 0;
  END IF;

  INSERT INTO Liked_songs
  VALUES ( new_id, user_id, song_id );
END;
$$
LANGUAGE plpgsql;


-- ----------------------------------------------------------------------------
-- На всякий случай далее добавил функции получения 
-- id пользователя, песни, плейлиста по имени
-- ----------------------------------------------------------------------------
-- Функция для получения уникального номера пользователя по его имени
-- ----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION user_id_by_name( IN user_name VARCHAR( 64 ) )
  RETURNS BIGINT AS
$$
BEGIN
  RETURN ( SELECT id FROM Users
           WHERE Users.name = user_name );
END;
$$
LANGUAGE plpgsql;
-- ----------------------------------------------------------------------------
-- Функция для получения уникального номера песни по ее названию
-- ----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION song_id_by_name( IN song_name VARCHAR( 64 ) )
  RETURNS BIGINT AS
$$
BEGIN
  RETURN ( SELECT id FROM Songs
           WHERE Songs.name = song_name );
END;
$$
LANGUAGE plpgsql;
-- ----------------------------------------------------------------------------
-- Функция для получения уникального номера плейлиста по его названию
-- ----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION playlist_id_by_name( IN playlist_name VARCHAR( 64 ) )
  RETURNS BIGINT AS
$$
BEGIN
  RETURN ( SELECT id FROM Playlist
           WHERE Playlist.name = playlist_name );
END;
$$
LANGUAGE plpgsql;
