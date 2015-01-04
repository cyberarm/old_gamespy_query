# GameSpy
Query old GameSpy servers, specifically, Command & Conquer: Renegade servers.

# Usage

Example of querying every server.
```ruby
@master_server = OldGameSpyQuery::MasterServer.new
@master_server.list.each do |addr|
  begin
    OldGameSpyQuery::ServerData.new("#{addr}").get_server_data("status")
  rescue => e
    p e
    next
  end
end
```
