# frozen_string_literal: true

module PerceptronSnakes
  module Graphics
    class Apple < ::Ruby2D::Square
      attr_reader :apple

      def initialize(apple)
        @apple = apple

        super(
          CoordinatesMapper.map_cell_to_square(@apple.x, @apple.y).merge({ color: Settings.colors.apple })
        )
      end

      def update!
        return unless apple.need_update?

        mapped_apple = CoordinatesMapper.map_cell_to_square(@apple.x, @apple.y)

        self.x = mapped_apple[:x]
        self.y = mapped_apple[:y]

        apple.updated!
      end

      private

      def mapper; end
    end
  end
end
