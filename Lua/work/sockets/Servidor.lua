--Sockets, Rede
require('socket');
--Constantes
porta = 3030;

servidor = socket.bind('*', porta);
io.write("Aguardando na porta "..porta.."\n");
cnx = servidor:accept();
io.write("Conexão realizada")
while true do
	msg = cnx:receive();
	io.write(msg .. "\n");
	io.write("Sua resposta > ");
	cnx:send(io.read() .. "\n");
end
io.read();
