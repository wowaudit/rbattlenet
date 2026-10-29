module RBattlenet
  module Wow
    class ProfessionSkillTier < RBattlenet::Endpoints::Base
      def self.path(skill_tier)
        RBattlenet.uri("data/wow/profession/#{skill_tier[:profession_id]}/skill-tier/#{skill_tier[:skill_tier_id]}?namespace=static-")
      end
    end
  end
end
