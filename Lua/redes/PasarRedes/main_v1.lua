function init_space(msg)
  -- ' ' : 0 ; '#' : -1 ; '{}'.format(n) : n ; '@' : -2
  space = {} ; space[1] = {}
  if msg:len() == 0 then
    for j=1,m do space[1][j] = 0 end
    for i=2,n do
      space[i] = {}
      for j=1,m do
        space[i][j] = -1
      end
    end
  else
    for i=1,n*m do
      -- finish
    end
  end
end

function space_to_str()
  local msg = ""
  for i=1,n do
    str = ""
    for j=1,m do
      if space[i][j]==-1 then
        str = str.."#"
      elseif space[i][j]==0 then
        str = str.." "
      elseif space[i][j]==-2 then
        str = str.."@"
      end
    end
    msg = msg..str
  end
  return msg
end

function init_players()
  players = {}
  for i=1,n_players do
    -- players[i] = {i,j,is_live,score}
    local px = math.floor(m/n_players-2)*i
    space[1][px],players[i] = i,{1,px,1,0}
  end
end

function init_enemies()
  enemies = {}
  for i=1,table.getn(en_px) do
    -- enemies[i] = {posx,posy,last_move}
    space[en_py[i]][en_px[i]],enemies[i] = -2,{en_py[i],en_px[i],0}
    -- never pass the limit of the space
    space[en_py[i]][en_px[i]+1] = 0 ; space[en_py[i]][en_px[i]-1] = 0
  end
end

function check(i_pl, i_en)
  
end

function enemies_move()
  -- last_move : 1:up ; 2:down ; 3:left ; 4:right ; 0:None
  for i=1,table.getn(enemies) do
    local r,c,lm = enemies[i][1],enemies[i][2],enemies[i][3]
    local move,way,c_move = false,true,{1,2,3,4}
    while not move and way do
      local nc_move = table.getn(c_move)
      if lm~=0 then a = lm 
      elseif nc_move~=0 then a = math.random(#c_move)
      end
      local dr,dc = deltar[a],deltac[a]
       if 0<r+dr and r+dr<=n and 0<c+dc and c+dc<=m then
        local can = space[r+dr][c+dc]~=-1 and space[r+dr][c+dc]~=-2
        if can then
          space[r][c],space[r+dr][c+dc] = 0,-2
          enemies[i] = {r+dr,c+dc,a} 
          move = true
        end
      end
      -- little bit elements
      if nc_move~=0 then table.remove(c_move,a) else way = false end
      lm = 0
    end
  end
end

function player_move(key)
  local r,c,live = players[i_player][1],players[i_player][2],players[i_player][3]
  local score = players[i_player][4]
  if live~=0 then
    local dr,dc = deltar[key],deltac[key]
    if 0<r+dr and r+dr<=n and 0<c+dc and c+dc<=m then
      space[r][c],space[r+dr][c+dc] = 0,i_player
      players[i_player] = {r+dr,c+dc,live,score}
    end
  end
end

function love.load()
  love.graphics.setBackgroundColor(0,0,0)
  n,m = 25,50
  en_px = {3,25}  -- init enemie Columns
  en_py = {3,16}  -- init enemie Rows
  deltar = { 0, 0, 1,-1}
  deltac = { 1,-1, 0, 0}
  init_space("")
  n_players = io.read()       -- number of players
  n_players = 4
  i_player = 1                -- player
  init_players()
  init_enemies()
end

function love.update(dt)
  if love.keyboard.isDown("up") then
   player_move(1)
  elseif love.keyboard.isDown("down") then
    player_move(2)
  elseif love.keyboard.isDown("left") then
    player_move(3)
  elseif love.keyboard.isDown("right") then
    player_move(4)
  end
  enemies_move()
end

function love.draw()
  --show_game(space)
end

