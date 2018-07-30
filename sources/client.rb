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
                    @client.puts("CLID: #{@id} #{@messagesToSend[0]}")
                    @messagesToSend = @messagesToSend.pop(@messagesToSend.length - 1)
                    sleep(timeout)
                end
            end
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