# frozen_string_literal: true

module PerceptronSnakes
  module Graphics
    class Wall
      class Side < ::Ruby2D::Rectangle
      end

      attr_reader :wall

      def initialize(wall)
        @wall = wall
        @sides = []

        build_sides
      end

      private

      def build_sides
        # upper
        @sides << Rectangle.new(
          x: 0,
          y: 0,
          width: PerceptronSnakes::CoordinatesMapper::WINDOW_SIDE_IN_PIXELS,
          height: Settings.sizes.cell,
          color: Settings.colors.wall
        )

        # left
        @sides << Rectangle.new(
          x: 0,
          y: 0,
          width: Settings.sizes.cell,
          height: PerceptronSnakes::CoordinatesMapper::WINDOW_SIDE_IN_PIXELS,
          color: Settings.colors.wall
        )

        # right
        @sides << Rectangle.new(
          x: PerceptronSnakes::CoordinatesMapper::WINDOW_SIDE_IN_PIXELS - Settings.sizes.cell,
          y: 0,
          width: Settings.sizes.cell,
          height: PerceptronSnakes::CoordinatesMapper::WINDOW_SIDE_IN_PIXELS,
          color: Settings.colors.wall
        )

        # bottom
        @sides << Rectangle.new(
          x: 0,
          y: PerceptronSnakes::CoordinatesMapper::WINDOW_SIDE_IN_PIXELS - Settings.sizes.cell,
          width: PerceptronSnakes::CoordinatesMapper::WINDOW_SIDE_IN_PIXELS,
          height: Settings.sizes.cell,
          color: Settings.colors.wall
        )
      end
    end
  end
end
