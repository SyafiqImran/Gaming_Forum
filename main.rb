require 'sinatra'
require 'sinatra/reloader' if development? #will run if in development mode
require 'pry'
require 'pg'
require 'bcrypt'

enable :sessions

def run_sql(sql)
  db = PG.connect(ENV['DATABASE_URL'] || {dbname: 'gaming_forum_db'})
  # 2 db to connect, either local machine or database url
  results = db.exec(sql)
  db.close
  return results
end

def user_found(users)
  if users.to_a.length > 0
    return users[0]
  else
    return nil
  end
end
# this is return the user (return technically tak perlu letak since implicit return)

def logged_in?
  !!session[:user_id] #is hash accesing user_id
end
# aims to give back a boolean (true or false)

def current_user
  if logged_in?
    user_id = session[:user_id]
    users = run_sql("SELECT * FROM users WHERE id= #{user_id}")
    user = user_found(users)
    return user
  else
    return nil
  end
end

# Users part

require_relative 'controllers/users_controller'

# Sessions part

require_relative 'controllers/session_controller'


# Games part

require_relative 'controllers/games_controller'

# Comment part

require_relative 'controllers/comments_controller'


# only gonna use current_user if someone is logged in..






# Like Part

post '/likes/:id' do
  comment_written = params['id'] #comment written

  comment = run_sql("SELECT * FROM comments WHERE comment_written = '#{comment_written}'")
  comment_id = comment.to_a[0]['id']
  game_id = comment.to_a[0]['game_id']
  user_id = current_user['id']
  username = current_user['username']
  
  
  run_sql("INSERT INTO likes(comment_id, user_id, game_id, username) VALUES('#{comment_id}','#{user_id}','#{game_id}', '#{username}')")

  redirect '/games'
end