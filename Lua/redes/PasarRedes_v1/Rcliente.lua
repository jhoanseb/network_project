require('socket')

io.write("Server > ");
server = io.read();
ports = {"4040","4041","4042"};
enable={1,1,1}
servers={}

function Who(server,enable,ports,servers)
	z=-1;
	for i=1,3 do
		if(enable[i]==1) then
			servers[i]=socket.connect(server, ports[i]);
			if(not(servers[i])) then 
				enable[i]=0;
			else
				servers[i]:send("%%Master\n");
				z=i;
				break;
			end
		end
	end
	return enable,servers,z;
end

enable,servers,actual=Who(server,enable,ports,servers)
msg=nil;
flt=false;
while true do
	print(ports[actual])
	if(actual==-1) then break end
	while servers[actual] do
		if(flt) then 
			servers[actual]:send(msg.."\n"); 
			servers[actual]=socket.connect(server, ports[actual]);
			flt=false;
		end
		io.write(" >");
		msg=io.read();
		servers[actual]:send(msg.."\n");
		servers[actual]=socket.connect(server, ports[actual]);
	end
	enable,servers,actual=Who(server,enable,ports,servers)
	flt=true;
end

