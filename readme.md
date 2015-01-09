# Old GameSpy Query
Query old GameSpy servers, specifically, Command & Conquer: Renegade servers.

# Usage

Example of querying every server.
```ruby
require "old_gamespy_query"
require "pp"

@master_server = OldGameSpyQuery::MasterServer.new

@master_server.list.each do |addr|
  begin
    @data = OldGameSpyQuery::ServerData.new("#{addr}").get_server_data("players")
    pp @data
  rescue Timeout::Error
    # Mask unresponsive servers
  end
end
```

# Note
Querying the master server requires 'gslist' and a modified version of [gamespy_query](https://github.com/SIXNetworks/gamespy_query/pull/1). Also the 'gslist' executable needs to be in the same directory from where your executing your program.
See http://aluigi.org/papers.htm#gslist.
