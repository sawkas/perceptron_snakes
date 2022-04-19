# frozen_string_literal: true

module PerceptronSnakes
  module Resources
    class Apple
      include Concerns::Updatable

      attr_reader :x, :y

      def initialize(snake)
        new_coordinates(snake)
      end

      def new_coordinates(snake)
        vector_excluding_wall = Settings.sizes.vector - 1

        loop do
          @x = rand(-vector_excluding_wall..vector_excluding_wall)
          @y = rand(-vector_excluding_wall..vector_excluding_wall)

          break unless snake.coordinates.include?([@x, @y])
        end

        need_update!
      end
    end
  end
end
