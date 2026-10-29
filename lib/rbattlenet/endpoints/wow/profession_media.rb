module RBattlenet
  module Wow
    class ProfessionMedia < RBattlenet::Endpoints::Base
      def self.path(id)
        RBattlenet.uri("data/wow/media/profession/#{id}?namespace=static-")
      end
    end
  end
end
