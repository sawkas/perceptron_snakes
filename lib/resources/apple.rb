# frozen_string_literal: true

module PerceptronSnakes
  module Resources
    class Apple
      include Concerns::Updatable

      attr_reader :x, :y

      def initialize
        new_coordinates
      end

      def new_coordinates
        vector_excluding_wall = Settings.sizes.vector - 1

        @x = rand(-vector_excluding_wall..vector_excluding_wall)
        @y = rand(-vector_excluding_wall..vector_excluding_wall)

        need_update!
      end
    end
  end
end
