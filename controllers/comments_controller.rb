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