# frozen_string_literal: true

module PerceptronSnakes
  module Resources
    class Snake
      include Concerns::Updatable

      BodyCell = Struct.new(:x, :y)

      DIRECTIONS = %i[up right down left].freeze
      POSSIBLE_STEPS_WITHOUT_APPLE = 100

      attr_accessor :direction
      attr_reader :body, :alive, :apples, :steps, :steps_without_apple

      def initialize
        @direction = DIRECTIONS.sample
        @body = build_body
        @alive = true
        @steps = 0
        @apples = 0
        @steps_without_apple = 0
      end

      #  Main method
      def step(wall, apple)
        new_head = build_new_head

        if wall.contains?(new_head.x, new_head.y) || body.include?(new_head) || POSSIBLE_STEPS_WITHOUT_APPLE == steps_without_apple
          @alive = false
        else
          if apple.x == new_head.x && apple.y == new_head.y
            @apples += 1
            @steps_without_apple = 0

            apple.new_coordinates(self)
          else
            @steps_without_apple += 1
            body.pop
          end

          body.unshift(new_head)
        end

        @steps += 1

        need_update!
      end

      def head
        body.first
      end

      def coordinates
        body.map { |cell| [cell.x, cell.y] }
      end

      def calculate_fitness
        steps + ((2**apples) + (apples**2.1) * 500) - (((0.25 ** steps)**1.3) * (apples**1.2))
      end

      private

      def build_body
        coordinates = case direction
        when :up
          head_x = rand((-Settings.sizes.vector+1)..(Settings.sizes.vector-1))
          head_y = rand((-Settings.sizes.vector+4)..Settings.sizes.vector-1)

          [[head_x, head_y], [head_x, head_y-1], [head_x, head_y-2]]
        when :down
          head_x = rand((-Settings.sizes.vector+1)..(Settings.sizes.vector-1))
          head_y = rand((-Settings.sizes.vector+1)..(Settings.sizes.vector-4))

          [[head_x, head_y], [head_x, head_y+1], [head_x, head_y+2]]
        when :right
          head_x = rand((-Settings.sizes.vector+4)..(Settings.sizes.vector-1))
          head_y = rand((-Settings.sizes.vector+1)..(Settings.sizes.vector-1))

          [[head_x, head_y], [head_x-1, head_y], [head_x-2, head_y]]
        when :left
          head_x = rand((-Settings.sizes.vector+1)..(Settings.sizes.vector-4))
          head_y = rand((-Settings.sizes.vector+1)..(Settings.sizes.vector-1))

          [[head_x, head_y], [head_x+1, head_y], [head_x+2, head_y]]
        end

        coordinates.map { |x, y| BodyCell.new(x, y) }
      end

      def build_new_head
        new_head = head.dup

        case direction
        when :up then new_head.y += 1
        when :down then new_head.y -= 1
        when :right then new_head.x += 1
        when :left then new_head.x -= 1
        end

        new_head
      end
    end
  end
end
