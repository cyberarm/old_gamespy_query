class OldGameSpyQuery
  class ServerData
    def initialize(address = "hostname:port")
      @address = address
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

      addr = @address.split(':')
      @socket = UDPSocket.new
      @socket.connect("#{addr[0]}", addr[1].to_i)
      begin
        timeout(5) {
          @socket.send("\\#{request}\\", 0)
          @data = @socket.recvfrom(4096)
        }
      rescue Timeout::Error
        raise Timeout::Error, "#{self.class}: The Server At '#{@address}' Did Not Respond In Time (Within 5 Seconds)"
      end

      @data[0].sub!("\\final\\", '')
      @gamespy_query = OldGameSpyQuery::Parser.new(@data, request).data
    end

    def data
      @gamespy_query
    end
  end
end
