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
  



  
  