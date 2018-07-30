require "ostruct"
require "socket"

module CarnetworkRuby
    class Server

        MessageData = Struct.new(:id, :content)

        @clients = nil
        @coder = nil
        @connected = nil
        @lastMessage = nil
        @server = nil

        @clientReceivingThreads = nil
        @newClientsThread = nil
        @receiveThread = nil

        def initialize(server, port, coder = 2)
            @clients = Array.new
            @clientReceivingThreads = Array.new
            @coder = coder
            @server = TCPServer.new(server, port)
            @connected = true
            @newClientsThread = Thread.new { handleNewClients }
        end

        def handleReceivingFromClient(id)
            while @connected do
                message = @clients[id].gets
                content = decode(message)
                @lastMessage = MessageData.new(id, content)
                puts @lastMessage.id
                puts @lastMessage.content
            end
        end

        def decode(data)
            if @coder < 0 || @coder >= 128
                puts "Coder must be between 0 and 127, pseudodecoding disabled"
                @coder = 0
            end
            for i in 0..data.length - 1
                asciiNo = data[i].ord
                asciiNo -= @coder
                if asciiNo < 0
                    asciiNo += 128;
                end
                data[i] = asciiNo.chr
            end
            return data
        end

        def handleNewClients
            while @connected do
                @clients.push(@server.accept)
                sendGreetMessage
                @clientReceivingThreads.push(Thread.new { handleReceivingFromClient(@clients.length - 1) })
            end
        end

        def sendGreetMessage
            @clients[-1].puts("CLID: #{@clients.length - 1}")
        end

        def sendToClient(message, id)
            begin
                @clients[id].puts(message)
            rescue
                puts "Client with this id doesn't exist! (Mind first id is 0 by default)"
            end
        end

        def broadcast(message)
            @clients.each do |client|
                client.puts(message)
            end
        end

        def receive
            return @server.gets
        end

    end
end