require('socket');
port = io.read();
server = socket.bind('*', port);
io.write("Waiting for client: "..port.."\n");
cnx = server:accept();
master=cnx:receive();
io.write("Connected \n")

enable={1,1,1};
ports={"4040","4041","4042"};
servers={}


function Who(server,enable,ports,myport,servers)
	for i=1,3 do
		if(myport==ports[i]) then enable[i] = 0 end
		if(enable[i]==1) then
			servers[i]=socket.connect("localhost", ports[i]);
			if(not(servers[i])) then 
				enable[i]=0;
			else
				servers[i]:send("%%None\n");
			end
		end
	end
	return enable,servers;
end
arc={};
z=1;
while true do
	print(master)
	if(master=="%%Master") then
		enable,servers=Who(server,enable,ports,port,servers);
		while true do
			msg = cnx:receive();
			cnx = server:accept();
			if(msg=="show()") then
				enable,servers=Who(server,enable,ports,port,servers);
				for i=1,3 do
					if(enable[i]==1) then
						servers[i]:send(msg.."\n");
					end
				end
				i=1;
				while not(arc[i]==nil) do 
					print(arc[i])
					i=i+1 
				end
			else
				if(msg=="%%Master") then
					master="%%Master";
					break;
				else
					if(not(msg == "%%None")) then
						io.write("< "..msg .. "\n");
						arc[z]=msg;
						z=z+1;
						enable,servers=Who(server,enable,ports,port,servers);
						for i=1,3 do
							if(enable[i]==1) then
								servers[i]:send(msg.."\n");
							end
						end
					end
				end
			end
		end
	else
		while true do
			cnx = server:accept();
			msg = cnx:receive();
			if((msg == "%%None")) then msg = cnx:receive() end
			if(msg=="show()") then
				i=1;
				while not(arc[i]==nil) do 
					print(arc[i])
					i=i+1 
				end
			else
				if(msg=="%%Master") then
					master="%%Master";
					break;
				else
					if(not(msg == "%%None") and not(msg == "%%Master")) then
						io.write("< "..msg .. "\n");
						arc[z]=msg;
						z=z+1;
					end
				end
			end
		end
	end
end

