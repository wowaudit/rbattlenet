module RBattlenet
  module Wow
    class RecipeMedia < RBattlenet::Endpoints::Base
      def self.path(id)
        RBattlenet.uri("data/wow/media/recipe/#{id}?namespace=static-")
      end
    end
  end
end
