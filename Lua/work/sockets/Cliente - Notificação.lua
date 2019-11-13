--Cliente
require('socket');
--Funções
function getPass()
	io.write("Insira sua senha: ");
	return io.read();
end

while true do
	io.write("Endereco do servidor: ");
	e = io.read();
	io.write("Porta: ");
	p = io.read();
	cliente = socket.connect(e, p);
	if cliente then
	io.write("Conectado no servidor: ".. e.." ["..p.."] \n");
	--Envia uma senha de autenticação
		cliente:send(getPass().."\n");
		--Aguarda autenticação
		if cliente:receive() == "$AUT" then
			io.write("Autenticacao Bem-Sucedida\n");
			repeat
				io.write("Envie uma notificacao: ");
				notification = io.read();
				cliente:send(notification .. "\n");
			until not cliente
		else
			io.write("Autenticacao falha\n");
		end
	end
end
