class OldGameSpyQuery
  class ServerData
    def initialize(address = "hostname:port")
      @address = address
      @data = []
    end

    def get_server_data(request = "status")
      case request
      when 'status'
      when 'players'
      when 'rules'
      when 'info'
      else
        raise "#{self.class}: can't parse \\#{request}\\"
      end

      retrieve_data(request)

      if @data.count >= 2 # Received multiple packets
        @gamespy_query = OldGameSpyQuery::Parser.new(@data, request, true).data
      else
        @gamespy_query = OldGameSpyQuery::Parser.new(@data, request).data
      end

      return data
    end

    def retrieve_data(request)
      addr = @address.split(':')
      @socket = UDPSocket.new
      @socket.connect("#{addr[0]}", addr[1].to_i)

      begin
        timeout(8) do
          @socket.send("\\#{request}\\", 0)
          loop do
            data = @socket.recvfrom(4096)
            _data = data[0].sub("\\final\\", '')
            a = data.dup
            a[0] = _data
            @data << a

            if data[0].include?("\\final\\")
              break
            end
          end
        end

      rescue Timeout::Error
        raise Timeout::Error, "#{self.class}: The Server At '#{@address}' Did Not Respond In Time (Within 5 Seconds)"
      end
    end

    def data
      @gamespy_query
    end
  end
end
