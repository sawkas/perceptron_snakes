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
        when :down
          [0, 1, 0, 0]
        when :left
          [0, 0, 1, 0]
        when :right
          [0, 0, 0, 1]
        end
      end

      def tail_direction
        tail = snake.body.last(2)
        penultimate_cell = tail.first
        last_cell = tail.last

        if penultimate_cell.y > last_cell.y
          [1, 0, 0, 0] # up
        elsif penultimate_cell.y < last_cell.y
          [0, 1, 0, 0] # down
        elsif penultimate_cell.x < last_cell.x
          [0, 0, 1, 0] # left
        elsif penultimate_cell.x > last_cell.x
          [0, 0, 0, 1] # right
        end
      end

      def vision
        vision = []

        1.upto(8).map do |i|
          coordinates = send("v#{i}_coordinates")

          vision << 1.to_f / coordinates.size

          # binary vision
          # vision << (coordinates.include?([apple.x, apple.y]) ? 1.0 : 0.0)
          apple_index = coordinates.index([apple.x, apple.y])
          vision << (apple_index.nil? ? 0 : (1.to_f / (apple_index + 1)))

          # binary vision
          # vision << ((coordinates & snake.coordinates).size.positive? ? 1.0 : 0.0)
          snake_index = coordinates.index((coordinates & snake.coordinates).first)
          vision << (snake_index.nil? ? 0 : (1.to_f / (snake_index + 1)))
        end

        vision
      end

      # The snake looks in 8 directions
      # H - head, B - Body, T - Tail, number - vector number
      # 8 . . . 1 . . . 2
      # . + . . + . . + .
      # . . + . + . + . .
      # . . . + + + . . .
      # 7 + + + H + + + 3
      # . . . + B + . . .
      # . . + . T . + . .
      # . + . . + . . + .
      # 6 . . . 5 . . . 4

      def v1_coordinates
        @v1_coordinates ||=
          (head_y + 1).upto(Settings.sizes.vector).each.with_index(1).map do |_, i|
            [head_x, head_y + i]
          end
      end

      def v2_coordinates
        @v2_coordinates ||=
          0.upto([v1_coordinates, v3_coordinates].map(&:size).min - 1).each.with_index(1).map do |_, i|
            [head_x + i, head_y + i]
          end
      end

      def v3_coordinates
        @v3_coordinates ||=
          (head_x + 1).upto(Settings.sizes.vector).each.with_index(1).map do |_, i|
            [head_x + i, head_y]
          end
      end

      def v4_coordinates
        @v4_coordinates ||=
          0.upto([v3_coordinates, v5_coordinates].map(&:size).min - 1).each.with_index(1).map do |_, i|
            [head_x + i, head_y - i]
          end
      end

      def v5_coordinates
        @v5_coordinates ||=
          (head_y - 1).downto(-Settings.sizes.vector).each.with_index(1).map do |_, i|
            [head_x, head_y - i]
          end
      end

      def v6_coordinates
        @v6_coordinates ||=
          0.upto([v5_coordinates, v7_coordinates].map(&:size).min - 1).each.with_index(1).map do |_, i|
            [head_x - i, head_y - i]
          end
      end

      def v7_coordinates
        @v7_coordinates ||=
          (head_x - 1).downto(-Settings.sizes.vector).each.with_index(1).map do |_, i|
            [head_x - i, head_y]
          end
      end

      def v8_coordinates
        @v8_coordinates ||=
          0.upto([v7_coordinates, v1_coordinates].map(&:size).min - 1).each.with_index(1).map do |_, i|
            [head_x - i, head_y + i]
          end
      end
    end
  end
end
