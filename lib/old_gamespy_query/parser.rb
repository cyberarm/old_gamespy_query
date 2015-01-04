class OldGameSpyQuery
  class Parser
    def initialize(string, mode = 'status')
      @string = string
      @mode   = mode
      @data   = {}
      @array  = @string[0].force_encoding('utf-8').strip.split("\\")
      @array.delete(@array.first) # Remove blank first item
      parse
    end

    def parse
      case @mode
      when 'status'
        status_parse
      when 'players'
        players_parse
      when 'rules'
        status_parse # Status and Rules appear compatible
      when 'info'
        status_parse # Status and Info appear compatible
      end

      @data["_gamespy"] = {
        "hostname" => "#{@string[1][3]}", "gamespy_port" => @string[1][1]
        }
    end

    def status_parse
      keys   = []
      values = []

      @array.each_with_index do |object, index|
        keys   << object if index.even?
        values << object if index.odd?
      end

      keys.each_with_index do |key, index|
        value = values[index]
        @data["#{key}"] = value
      end
    end

    def players_parse
      sub_hash = {}
      keys   = []
      values = []
      num = 0

      @array.each_with_index do |object, index|
        keys   << object if index.even?
        values << object if index.odd?
      end

      keys.each_with_index do |key, index|
        value = values[index]
        if key.end_with?("#{num}")
          sub_hash["#{key}"] = value
        elsif key.end_with?("#{num+1}")
          @data["player_#{num}"] = sub_hash
          sub_hash = {}
          num+=1
          sub_hash["#{key}"] = value
        end
      end
    end

    def data
      @data
    end
  end
end
