# frozen_string_literal: true

module PerceptronSnakes
  module NeuralNetwork
    class Input
      def initialize(snake, wall, apple)
        @snake = snake
        @wall = wall
        @apple = apple

        @head_x = snake.head.x
        @head_y = snake.head.y
      end

      def call
        vision + direction + tail_direction
      end

      private

      attr_reader :snake, :wall, :apple, :head_x, :head_y

      def direction
        case snake.direction
        when :up
          [1, 0, 0, 0]
        when :right
          [0, 1, 0, 0]
        when :down
          [0, 0, 1, 0]
        when :left
          [0, 0, 0, 1]
        end
      end

      def tail_direction
        tail = snake.body.last(2)
        penultimate_cell = tail.first
        last_cell = tail.last

        if penultimate_cell.x > last_cell.x
          [0, 1, 0, 0] # right
        elsif penultimate_cell.x < last_cell.x
          [0, 0, 0, 1] # left
        elsif penultimate_cell.y > last_cell.y
          [1, 0, 0, 0] # up
        elsif penultimate_cell.y < last_cell.y
          [0, 0, 1, 0] # down
        end
      end

      def vision
        distance_to_wall = []
        is_there_an_apple = []
        is_there_a_snake = []

        1.upto(8).map do |i|
          coordinates = send("v#{i}_coordinates")

          distance_to_wall << coordinates.size.to_f / (Settings.sizes.vector * 2 + 1) # length
          is_there_an_apple << (coordinates.include?([apple.x, apple.y]) ? 1 : 0)
          is_there_a_snake << ((coordinates & snake.coordinates).size.positive? ? 1 : 0)
        end

        distance_to_wall + is_there_an_apple + is_there_a_snake
      end

      # The snake looks in 8 directions
      # H - head, B - Body, T - Tail, number - vector number
      # 3 . . . 4 . . . 5
      # . + . . + . . + .
      # . . + . + . + . .
      # . . . + + + . . .
      # 2 + + + H + + + 6
      # . . . + B + . . .
      # . . + . T . + . .
      # . + . . + . . + .
      # 1 . . . 8 . . . 7

      def v1_coordinates
        @v1_coordinates ||=
          0.upto([v8_coordinates, v2_coordinates].map(&:size).min - 1).each.with_index(1).map do |_, i|
            [head_x - i, head_y - i]
          end
      end

      def v2_coordinates
        @v2_coordinates ||=
          (head_x - 1).downto(-Settings.sizes.vector).each.with_index(1).map do |_, i|
            [head_x - i, head_y]
          end
      end

      def v3_coordinates
        @v3_coordinates ||=
          0.upto([v2_coordinates, v4_coordinates].map(&:size).min - 1).each.with_index(1).map do |_, i|
            [head_x - i, head_y + i]
          end
      end

      def v4_coordinates
        @v4_coordinates ||=
          (head_y + 1).upto(Settings.sizes.vector).each.with_index(1).map do |_, i|
            [head_x, head_y + i]
          end
      end

      def v5_coordinates
        @v5_coordinates ||=
          0.upto([v4_coordinates, v6_coordinates].map(&:size).min - 1).each.with_index(1).map do |_, i|
            [head_x + i, head_y + i]
          end
      end

      def v6_coordinates
        @v6_coordinates ||=
          (head_x + 1).upto(Settings.sizes.vector).each.with_index(1).map do |_, i|
            [head_x + i, head_y]
          end
      end

      def v7_coordinates
        @v7_coordinates ||=
          0.upto([v6_coordinates, v8_coordinates].map(&:size).min - 1).each.with_index(1).map do |_, i|
            [head_x + i, head_y - i]
          end
      end

      def v8_coordinates
        @v8_coordinates ||=
          (head_y - 1).downto(-Settings.sizes.vector).each.with_index(1).map do |_, i|
            [head_x, head_y - i]
          end
      end
    end
  end
end
