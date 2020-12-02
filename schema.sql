-- Basic Draft --
-- Page 1 --
    -- Contains a box where u can login users 
        -- takes in username/email and password
    -- Box in the center of page
    -- with a link that can lead to account creation
-- Page 2 -- (must logged in first to access)
    -- Ideally this is the main page where all posts go ? 
        -- all in center of the page 
    -- provide a link so that people can post, add new post .. 
        -- should ada like a small box 
    -- Post contain comments ? 
        -- if in JS can use create element with append child under the post ?
-- Page 3 -- 
    -- For adding a post
        -- make it like food truck , add new stuff etc
-- Page 4 --
    -- Account creation
        -- take in first_name , last_name, username , email and password
        -- must digest password before putting in database..
        -- when done redirect to login page
-- Page 5 --
    -- Specific about a post with a thread of comments ? 



-- Database -- 

CREATE DATABASE gaming_forum_db;

CREATE TABLE users(id SERIAL PRIMARY KEY, first_name TEXT, last_name TEXT, username TEXT, email TEXT, password_digest TEXT);

CREATE TABLE games(id SERIAL PRIMARY KEY, name TEXT, image_url TEXT, date_of_post TEXT);

CREATE TABLE comments(id SERIAL PRIMARY KEY, comment_written TEXT, comment_poster TEXT, game_name TEXT);