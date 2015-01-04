require "old_gamespy_query"
require "pp"

@master_server = OldGameSpyQuery::MasterServer.new

@master_server.list.each do |addr|
  begin
    @data = OldGameSpyQuery::ServerData.new("#{addr}").get_server_data("players")
    pp @data
  rescue Timeout::Error
  end
end
