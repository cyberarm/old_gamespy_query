class OldGameSpyQuery
  class QueryObject
    attr_accessor :data
    def initialize(status, players, general, data)
      @data = OpenStruct.new(:status => status, :players => players, :general => general, :data => data)
    end
  end

  class Parser
    def initialize(socket_array, mode = 'status', multi_packet = false)
      @socket_array = socket_array
      @mode   = mode
      @multi_packet = multi_packet
      @data   = {}

      @players = {}
      @status  = {}
      @general = {}
      parse

      @struct = OldGameSpyQuery::QueryObject.new(@status, @players, @general, @data)
    end

    def parse
      case @mode
      when 'status'
        status_parse
      when 'players'
        players_parse
      when 'rules'
        general_parse
      when 'info'
        general_parse
      end

      @data["status"]   = @status
      @data["players"]  = @players
      @data["general"]  = @general
      @data["_gamespy"] = {
        "hostname" => "#{@socket_array[0][1][3]}",
        "gamespy_port" => @socket_array[0][1][1]
        }
    end

    def array_object(index = 0)
      if @socket_array.count >= 2
        @socket_array[index][0].force_encoding('utf-8').strip.split("\\")
      else
        @socket_array[0].force_encoding('utf-8').strip.split("\\")
      end
    end

    # Generic key -> value
    def general_parse(_index = 0)
      array  = @socket_array[_index][0].force_encoding('utf-8').strip.split("\\")
      array.delete(array.first) # Remove blank first item

      keys   = []
      values = []

      array.each_with_index do |object, index|
        keys   << object if index.even?
        values << object if index.odd?
      end

      keys.each_with_index do |key, index|
        value = values[index]
        @status["#{key}"] = value if @mode == 'status'
        @general["#{key}"]= value if @mode != 'status'
      end
    end

    def status_parse
      if @multi_packet
        @socket_array.each_with_index do |packet, index|
          array  = @socket_array[index][0].force_encoding('utf-8').strip.split("\\")
          array.delete(array.first) # Remove blank first item

          if array.find{|string| true if string == "gamename"}
            general_parse(index)
          end
          if array.find {|string| true if string == ("player_0")}
            puts "PLAYERS"
            players_parse(index)
          end
        end
      else
        general_parse
      end
    end

    def players_parse(_index = 0)
      array  = array_object(_index)
      array.delete(array.first) # Remove blank first item

      sub_hash = {}
      keys   = []
      values = []
      num = 0

      array.each_with_index do |object, index|
        keys   << object if index.even?
        values << object if index.odd?
      end

      keys.each_with_index do |key, index|
        value = values[index]
        if key.end_with?("#{num}")
          sub_hash["#{key}"] = value
        elsif key.end_with?("#{num+1}")
          @players["player_#{num}"] = sub_hash
          sub_hash = {}
          num+=1
          sub_hash["#{key}"] = value
        end
      end
    end

    def data
      @struct.data
    end
  end
end
