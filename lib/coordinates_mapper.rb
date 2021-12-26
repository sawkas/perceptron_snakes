# frozen_string_literal: true

# Logic coordinates
# unit segment = Settings.sizes.cell
# . . . . . Y . . . . .
# . . . . . + . . . . .
# . . . . . + . . . . .
# . . . . . + . . . . .
# + + + + + + + + + + X
# . . . . . + . . . . .
# . . . . . + . . . . .
# . . . . . + . . . . .
# . . . . . + . . . . .

# Graphics coordinates
# unit segment = 1 pixel
# + + + + + + + + + + X
# + . . . . . . . . . .
# + . . . . . . . . . .
# + . . . . . . . . . .
# + . . . . . . . . . .
# + . . . . . . . . . .
# + . . . . . . . . . .
# + . . . . . . . . . .
# Y . . . . . . . . . .

module PerceptronSnakes
  class CoordinatesMapper
    WINDOW_SIDE_IN_PIXELS = ((Settings.sizes.vector * 2) + 1) * Settings.sizes.cell

    GRAPHICAL_CENTER = (WINDOW_SIDE_IN_PIXELS / 2) - (Settings.sizes.cell / 2)

    class << self
      def map_cell_to_square(x, y)
        graphical_x = GRAPHICAL_CENTER + x * Settings.sizes.cell
        graphical_y = GRAPHICAL_CENTER - y * Settings.sizes.cell

        { x: graphical_x, y: graphical_y, size: Settings.sizes.cell }
      end
    end
  end
end
