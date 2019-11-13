require('socket')

io.write("Escolha um servidor > ");
servidor = io.read();
io.write("Escolha uma porta > ");
porta = io.read();
cliente = socket.connect(servidor, porta);
if cliente then
	io.write("Conectado com sucesso!\n");
	while true do
		io.write("Envie um mensagem >");
		cliente:send(io.read().."\n");
		reply = cliente:receive();
		io.write(reply .. "\n");
	end
end
