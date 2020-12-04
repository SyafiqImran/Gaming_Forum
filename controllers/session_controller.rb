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
  