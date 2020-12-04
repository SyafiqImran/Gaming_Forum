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
  