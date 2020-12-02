require 'sinatra'
require 'sinatra/reloader'
require 'pry'
require 'pg'
require 'bcrypt'

enable :sessions

def run_sql(sql)
  db = PG.connect(ENV['DATABASE_URL'] || {dbname: 'gaming_forum_db'})
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
  game_date_of_post = params['date_of_post']
  run_sql("INSERT INTO games(name, image_url, date_of_post) VALUES('#{game_name}','#{game_image_url}','#{game_date_of_post}')")
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
  password_digest = BCrypt::Password.create(user_password)

  run_sql("INSERT INTO users(first_name, last_name, username, email, password_digest) VALUES('#{user_first_name}','#{user_last_name}','#{user_username}','#{user_email}','#{password_digest}')")

  redirect '/users/done'

end

get '/users/done' do
  erb :'/users/donenew'
end




# Sessions Part


get '/' do

  erb :'/sessions/login'
  
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
      erb :'/sessions/login'
    end
end