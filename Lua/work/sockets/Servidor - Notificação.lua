--Servidor principal!
require('socket');
--Constantes
senha = "cp27vc95@!";
port = 3030;
--Cria o servidor
local host = socket.bind('*', port);
io.write("Servidor local criado na porta [",port,"]\n");
io.write("Aguardando conexao...\n");
local cnx = host:accept();
ip = cnx:getpeername();
logFile = assert(io.open("logServer"..ip..".txt", "w"));
io.write("Cnx. Estabelecida.("..ip..")\n");
io.write("Aguardando autenticacao!\n");
---[[
if cnx:receive() == senha then
	cnx:send("$AUT\n"); --Envia uma flag de Autenticação com sucesso
	io.write("Autenticacao de " .. ip .." completa!\n");
	logFile:write(ip," se conectou ao servidor com a senha: ".. senha.."\n");
	while true do
		note = cnx:receive();
		logFile:write("Notificacao("..ip.."): "..note.." ["..os.date().."] " .. "\n");
		io.write("Nova notificacao de ".. ip .. "("..os.date() .. ")\n");
	end
else
	cnx:send("$NAUT\n"); --envia uma flag de autenticação falha
	host:close();
end
--]]

