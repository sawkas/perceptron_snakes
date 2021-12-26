# frozen_string_literal: true

module PerceptronSnakes
  module Resources
    class Wall
      def contains?(x, y)
        x.abs == Settings.sizes.vector || y.abs == Settings.sizes.vector
      end
    end
  end
end
