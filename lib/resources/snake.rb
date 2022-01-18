# frozen_string_literal: true

module PerceptronSnakes
  module Resources
    class Snake
      include Concerns::Updatable

      BodyCell = Struct.new(:x, :y)

      DIRECTIONS = %i[up right down left].freeze

      attr_accessor :direction
      attr_reader :body, :alive, :apples, :steps

      def initialize
        @body = Array[BodyCell.new(0, 0), BodyCell.new(-1, 0)]
        @direction = DIRECTIONS.sample
        @alive = true
        @steps = 0
        @apples = 0
      end

      #  Main method
      def step(wall, apple)
        new_head = build_new_head

        if wall.contains?(new_head.x, new_head.y) || body.include?(new_head)
          @alive = false
        else
          if apple.x == new_head.x && apple.y == new_head.y
            @apples += 1

            apple.new_coordinates(self)
          else
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
        steps + (2**apples + (apples**2.1) * 500) - ((apples**1.2) * (steps * 0.25)**1.3)
      end

      private

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
