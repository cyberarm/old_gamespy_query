class OldGameSpyQuery
  class MasterServer
    attr_reader :query, :list
    def initialize(gamename = "ccrenegade", master_server = "renmaster.cncnet.org:28900", enctype = 0)
      @query = GamespyQuery::Master.new(nil, gamename, nil, nil, master_server, enctype)
      get_server_list
    end

    def get_server_list
      @list = @query.get_server_list
    end
  end
end
