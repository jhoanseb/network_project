n,m = 25,50

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
  return space
end

function space_to_str(space)
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

function show_game(space)
  for i=1,n do
    local str = ""
    for j=1,m do
      if space[i][j]==-1 then
        str = str.."#"
      elseif space[i][j]==0 then
        str = str.." "
      elseif space[i][j]==-2 then
        str = str.."@"
      else
        str = str..tostring(space[i][j])
      end
    end
    print(str)
  end
end

function init_players(n_players,space)
  local players = {}
  for i=1,n_players do
    -- players[i] = {posx,posy,is_live}
    space[1][i],players[i] = i,{1,i,1}
  end
  return space,players
end

function player_move(space,i_player,key)
  local r,c,live = players[i_player][1],players[i_player][2],players[i_player][3]
  if live~=0 then
    local dr,dc = 0,0
    if key=="w" then dr = -1
    elseif key=="s" then dr = 1
    elseif key=="a" then dc = -1
    elseif key=="d" then dc = 1
    end
    if 0<r+dr and r+dr<=n and 0<c+dc and c+dc<=m then
      space[r][c],space[r+dr][c+dc] = 0,i_player
      players[i_player] = {r+dr,c+dc}
    end
  end
  return space,players
end

function init_enemies(n_enemies,space)
  local enemies = {}
  for i=1,n_enemies do
    -- enemies[i] = {posx,posy,last_move}
    space[1][m+1-i],enemies[i] = -2,{1,m+1-i,0}
  end
  return space,enemies
end

function enemie_move(space)
  -- last_move : 1:up ; 2:down ; 4:right ; 3:left ; 0:None
  local deltar = { 0, 0, 1,-1}
  local deltac = { 1,-1, 0, 0}
  for i=1,table.getn(enemies) do
    local r,c,lm = enemies[i][1],enemies[i][2],enemies[i][3]
    local move,way,c_move = false,true,{1,2,3,4}
    while not move and way do 
      if lm~=0 then a = lm else a = math.random(#c_move) end 
      local dr,dc = deltar[a],deltac[a]
      if 0<r+dr and r+dr<=n and 0<c+dc and c+dc<=m then
        local can = space[r+dr][c+dc]~=-1 or space[r+dr][c+dc]~=-2
        if can then
          space[r][c],space[r+dr][c+dc] = 0,-2
          enemies[i] = {r+dr,c+dc,a} 
          move = true
        end
      end
       -- little bit elements
      if table.getn(c_move)~=0 then table.remove(c_move,a) else way = false end
      lm = 0
      show_game(space)
      --print(table.concat( enemies, ", "))
      print("durante "..table.concat( c_move, ", "))
      print()
    end
    print("final "..table.concat( c_move, ", "))
  end
  return space,enemies
end

function main_game()
  space = init_space("")
  n_players,n_enemies = 4,10 ; execution = {}
  -- key[i] = {w,a,s,d}
  keys = {0,0,0,0}
  space,players = init_players(n_players,space)
  space,enemies = init_enemies(n_enemies,space)
  for i=1,n_players do table.insert(execution,{1,i}) end
  for i=1,n_enemies do table.insert(execution,{-2,i}) end
  --os.execute("cls")
  --Bind.create("up",function() key[0]=1 end)
  show_game(space)
  while n_players>0 do
    key = io.read() --  change
    --os.execute("cls")
    space,players = player_move(space,1,key)
    space,enemies = enemie_move(space)
    show_game(space)
  end
end

--for i in pairs(execution) do print(table.concat(execution[i],",")) end
main_game()

-- Cambios faltantes:
-- Implementar la cola de ejecución/prioridad,
-- Los enemigos siempre se muevan cada vez que les toque,
-- mejorar la recepción de datos con el teclado,
-- si se desea cambiar la posición de inicio de los personajes,
-- perder personaje,
-- conversion de los datos para el envio del paquete,
-- mejorar los enemigos (recorrido),
-- cambiar init_enemies y init_players
