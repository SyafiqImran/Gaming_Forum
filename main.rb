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




# only gonna use current_user if someone is logged in..

# Games part

get '/games' do
  games = run_sql("SELECT * FROM games ORDER BY id")
  
  erb :'/games/index', locals:{
    games: games,
    
  }
end

get '/games/new' do
  erb :'/games/new'
end

post '/games' do
  game_name = params['game_name']
  game_image_url = params['game_image_url']
  game_date_of_post = Time.now.strftime("%c")
  username = current_user['username']
  user_id = current_user['user_id'].to_i
  
  
  
  run_sql("INSERT INTO games(name, image_url, date_of_post, username, user_id) VALUES('#{game_name}','#{game_image_url}','#{game_date_of_post}', '#{username}', '#{user_id}')")
  

  redirect '/games'
end

get '/games/:name' do
  game_name = params['name']
  username = current_user['username']
  game_chosen = run_sql("SELECT * FROM games WHERE name = '#{game_name}'")
  game_id = game_chosen.to_a[0]['id']
  comments = run_sql("SELECT * FROM comments WHERE game_id = '#{game_id}'") #display comment

  
  game = run_sql("SELECT * FROM games WHERE name = '#{game_name}'")
  game_display = game.to_a[0]
  
  erb :'/games/moredetails', locals:{
    game_display: game_display,
    comments: comments,

  }
end

get '/games/:name/edit' do
  game_name = params['name']
  
  game = run_sql("SELECT * FROM games WHERE name = '#{game_name}'")
  game_display = game.to_a[0]

  erb :'/games/edit', locals:{
    game_display: game_display,

  }

end

patch '/games/:name' do
  game_name = params['name']
  
  game_image_url = params['image_url']
  date_of_post = Time.now.strftime("%c")+'(edited)'
  game = run_sql("UPDATE games SET name='#{game_name}', image_url ='#{game_image_url}', date_of_post = '#{date_of_post}'")
  
  redirect "/games/'#{game_name}'"
end

delete '/games/:name' do
  game_name = params['name']
  game = run_sql("SELECT * FROM games WHERE name = '#{game_name}'") 
  game_id = game.to_a['id']
  run_sql("DELETE FROM games WHERE name = '#{game_name}'")
  run_sql("DELETE FROM likes WHERE game_id = '#{game_id}'")
  run_sql("DELETE FROM comments WHERE game_id = '#{game_id}'")
  redirect '/games'

end



# Users part

get '/users/new' do
  erb :'/users/new'
end

post '/users' do
  user_first_name = params['first_name']
  user_last_name = params['last_name']
  user_username = params['username']
  user_email = params['email']
  user_password = params['password']
  user_profile_picture = params['profile_picture']
  password_digest = BCrypt::Password.create(user_password)

  run_sql("INSERT INTO users(first_name, last_name, username, email, password_digest, profile_picture) VALUES('#{user_first_name}','#{user_last_name}','#{user_username}','#{user_email}','#{password_digest}','#{user_profile_picture}')")

  redirect '/users/done'

end

get '/users/done' do
  erb :'/users/donenew'
end




# Sessions Part


get '/' do
  error = ''
  erb :'/sessions/login', locals:{
    error: error
  }
  
end

post '/sessions' do
  user_username = params["username"]
  user_password = params["password"]

  users = run_sql("SELECT * FROM users WHERE username = '#{user_username}'")
  user = user_found(users) #kalau salah masuk data dia refresh rather than error
  # a collection of records sbb SELECT
  # psql is the reason SELECT is not very accurate (rather than only 1 thing we want) it will return a collection of records..
  # will access first user from our group = index 0..
  # no need to loop since its a collection of 1..
  # binding.pry
  
  #line 109 = will automatically hashes the new password and compared it to the password_digest..
  # BCrypt::Password.new = is for when we take a password from a user provided then checking it to our database (password digest)
  
  if user && BCrypt::Password.new(user['password_digest']) == params['password']
    # log the user in
    session[:user_id] = user['id'] #this line log a user in
    # session is a hash that sinatra provides u.. 
    # making a key in the session hash..
      # key  = :user_id 
      # value = user['id']
    # so this how cookies are created
    # cookie = a piece of data that lives on ur (browser) computer , web server will send to browser . (cookie) is like a key..
    # the cookie as long as it lives on the browser , we will stay logged in since server logged us in ..
    # analogy = customs gate - we(human) go to server (custom person) and gives cookie(passport) approves (giving a stamp to us to pass)
    # then cookie(passport) is used again to pass again..
    redirect '/games'
  else
    error = "PLEASE KEY IN THE CORRECT DETAILS"
    erb :'/sessions/login', locals:{
      error: error
    }
  end
end

delete '/sessions' do
  session[:user_id] = nil
  # id gets remove in the session hash
  # reassigning the id is much more correct term.

  redirect '/'

end


# comment part

get '/comments/:name/new' do
  game_name = params['name']
  
  erb :'/comments/new', locals:{
    game_name: game_name,
  }
end

post '/comments/:name' do
  comment_written = params['comment']
  
  game_name = params['name']
  
  game_chosen = run_sql("SELECT * FROM games WHERE name = '#{game_name}'")
  game_id = game_chosen.to_a[0]['id']
  username = current_user['username'] #ni function yeeeeee
  user_id = current_user['id']
  time_of_post = Time.now.strftime("%c")
  
  run_sql("INSERT INTO comments(comment_written, user_id, game_id, username, time_of_post) VALUES('#{comment_written}','#{user_id}','#{game_id}','#{username}', '#{time_of_post}')")
  
  redirect '/games'
  # redirect '/games/' + game_name + ''
  # This page isn’t workinglocalhost didn’t send any data.
   #ERR_EMPTY_RESPONSE

  #redirect "/games/'#{game_name}'"
  # This page isn’t workinglocalhost didn’t send any data.
   #ERR_EMPTY_RESPONSE

end

get '/comments/:id/edit' do
  user_id = params['id']
  comment = run_sql("SELECT * FROM comments WHERE user_id = '#{user_id}'")
  comment_written = comment[0]

  erb :'/comments/edit', locals:{
    comment_written: comment_written
  }
  
end


patch '/comment/:id' do
  user_id = params['id']
  comment_written = params['comment_written']
  time_of_post = Time.now.strftime("%c") + '(edited)'
  comment = run_sql("UPDATE comments SET comment_written='#{comment_written}', time_of_post = '#{time_of_post}' WHERE user_id='#{user_id}'")

  redirect '/games'
end

delete '/comments/:id' do

  if current_user()['id'] == '1'
    comments = run_sql("SELECT * FROM comments")
    game_id = ''
    comments.each do |comment|
      game_id = comment['game_id']
    end
    
    run_sql("DELETE FROM comments WHERE game_id = '#{game_id}'")
    redirect '/games'
  else
    comment_written = current_user()['id']
    
    run_sql("DELETE FROM comments WHERE user_id=#{comment_written};")
    redirect '/games'
  end
  
end

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