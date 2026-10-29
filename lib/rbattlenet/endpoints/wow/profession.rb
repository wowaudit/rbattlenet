module RBattlenet
  module Wow
    class Profession < RBattlenet::Endpoints::Base
      def self.path(id)
        RBattlenet.uri("data/wow/profession/#{id}?namespace=static-")
      end

      def self.index_path
        RBattlenet.uri("data/wow/profession/index?namespace=static-")
      end
    end
  end
end
