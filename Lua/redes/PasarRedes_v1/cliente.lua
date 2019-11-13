require('socket')

io.write("Server > ");
server = io.read();
io.write("Port > ");
port = io.read();
client0 = socket.connect(server, port);
if client0 then
	io.write("Connected!\n");
	while true do
		io.write(" >");
		client0:send(io.read().."\n");
		reply = client0:receive();
		io.write("< "..reply .. "\n");
	end
end