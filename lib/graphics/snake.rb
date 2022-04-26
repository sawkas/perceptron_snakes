# frozen_string_literal: true

module PerceptronSnakes
  module Graphics
    class Snake
      class GraphicCell < ::Ruby2D::Square
      end
      attr_reader :snake

      def initialize(snake)
        @snake = snake
        @graphic_cells = []

        udpdate_or_build_body_cells
      end

      def update!
        return unless snake.need_update?

        udpdate_or_build_body_cells

        snake.updated!
      end

      def remove
        @graphic_cells.map(&:remove)
      end

      private

      attr_reader :graphic_cells

      def udpdate_or_build_body_cells
        snake.body.each_with_index do |body_cell, index|
          graphic_cell = graphic_cells[index]
          mapped_cell = Utils::CoordinatesMapper.map_cell_to_square(body_cell.x, body_cell.y)

          if graphic_cell
            graphic_cell.x = mapped_cell[:x]
            graphic_cell.y = mapped_cell[:y]
          else
            @graphic_cells << GraphicCell.new(mapped_cell.merge({ color: Settings.colors.snake }))
          end
        end
      end
    end
  end
end
