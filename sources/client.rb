require 'socket'

module CarnetworkRuby
    class Client

        @messagesToSend = nil
        @client = nil
        @connected = nil
        @id = nil
        @sendingThread = nil

        def initialize(server, port)
            @messagesToSend = Array.new
            @client = TCPSocket.new(server, port)
            @connected = true
            @sendingThread = Thread.new { handleSend }
            handleId
        end

        def receive
            return @client.gets
        end

        def send(message)
            @messagesToSend.push(message)
        end

        def handleSend(timeout = 0.5)
            while @connected do
                if @messagesToSend.length > 0
                    messageToSend = encode("CLID: #{@id} #{@messagesToSend[0]}", 2)
                    @client.puts(messageToSend)
                    @messagesToSend = @messagesToSend.pop(@messagesToSend.length - 1)
                    sleep(timeout)
                end
            end
        end

        def encode(data, coder)
            if coder < 0 || coder >= 128
                puts "Coder must be between 0 and 127, encoding disabled"
                coder = 0
            end
            for i in 0..data.length - 1
                asciiNo = data[i].ord
                asciiNo += coder
                if asciiNo >= 128
                    asciiNo -= 128;
                end
                data[i] = asciiNo.chr
            end
            return data
        end

        def handleId
            data = @client.gets
            @id = data["CLID: ".length .. -2]
        end

        def disconnect
            @connected = false
            @client.close
        end

        attr_reader :messagesToSend

    end
end