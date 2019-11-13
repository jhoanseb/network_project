require('socket');
port = io.read();
server = socket.bind('192.168.1.174', port);
io.write("Waiting for client: "..port.."\n");
cnx = server:accept();
io.write("Connected \n")
while true do
	msg = cnx:receive();
	io.write("< "..msg .. "\n");
	io.write(" > ");
	cnx:send(io.read() .. "\n");
end
io.read();