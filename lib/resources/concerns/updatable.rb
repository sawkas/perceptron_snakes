# frozen_string_literal: true

module PerceptronSnakes
  module Resources
    module Concerns
      module Updatable
        def need_update?
          @need_update || false
        end

        def need_update!
          @need_update = true
        end

        def updated!
          @need_update = false
        end
      end
    end
  end
end
