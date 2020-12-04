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

CREATE TABLE users(id SERIAL PRIMARY KEY, first_name TEXT, last_name TEXT, username TEXT, email TEXT, password_digest TEXT, profile_picture TEXT);

CREATE TABLE games(id SERIAL PRIMARY KEY, name TEXT, image_url TEXT, date_of_post TEXT, user_id INTEGER, username TEXT);

CREATE TABLE comments(id SERIAL PRIMARY KEY, comment_written TEXT, user_id INTEGER, game_id INTEGER, username TEXT, time_of_post TEXT);

CREATE TABLE likes(id SERIAL PRIMARY KEY, comment_id INTEGER, user_id INTEGER, game_id INTEGER, username TEXT);
ALTER TABLE likes ADD CONSTRAINT comment_id_and_user_id UNIQUE (comment_id, user_id);

ALTER TABLE likes ADD CONSTRAINT unique_post_id_and_user_id UNIQUE (post_id, user_id);

INSERT INTO comments (message, post_id, user_id) VALUES ('this is hadi''s first comment', 1, 1);


<h1>TEST</h1>
<h2>TEST</h2>
<h3>TEST</h3>
<h4>TEST</h4>
<h5>TEST</h5>
<h6>TEST</h6>

<p>TEST</p>
<span>TEST</span>

h1 {
    display: block;
    font-size: 2em;
    margin-block-start: 0.67em;
    margin-block-end: 0.67em;
    margin-inline-start: 0px;
    margin-inline-end: 0px;
    font-weight: bold;
}
h2 {
    display: block;
    font-size: 1.5em;
    margin-block-start: 0.83em;
    margin-block-end: 0.83em;
    margin-inline-start: 0px;
    margin-inline-end: 0px;
    font-weight: bold;
}
h3 {
    display: block;
    font-size: 1.17em;
    margin-block-start: 1em;
    margin-block-end: 1em;
    margin-inline-start: 0px;
    margin-inline-end: 0px;
    font-weight: bold;
}
h4 {
    display: block;
    margin-block-start: 1.33em;
    margin-block-end: 1.33em;
    margin-inline-start: 0px;
    margin-inline-end: 0px;
    font-weight: bold;
}
h5 {
    display: block;
    font-size: 0.83em;
    margin-block-start: 1.67em;
    margin-block-end: 1.67em;
    margin-inline-start: 0px;
    margin-inline-end: 0px;
    font-weight: bold;
}
h6 {
    display: block;
    font-size: 0.67em;
    margin-block-start: 2.33em;
    margin-block-end: 2.33em;
    margin-inline-start: 0px;
    margin-inline-end: 0px;
    font-weight: bold;
}

p {
    display: block;
    margin-block-start: 1em;
    margin-block-end: 1em;
    margin-inline-start: 0px;
    margin-inline-end: 0px;
}


