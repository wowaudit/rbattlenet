module RBattlenet
  module Wow
    class Recipe < RBattlenet::Endpoints::Base
      def self.path(id)
        RBattlenet.uri("data/wow/recipe/#{id}?namespace=static-")
      end
    end
  end
end
