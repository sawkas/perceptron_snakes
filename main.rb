# frozen_string_literal: true

set title: 'PerceptronSnakes',
    width: PerceptronSnakes::CoordinatesMapper::WINDOW_SIDE_IN_PIXELS,
    height: PerceptronSnakes::CoordinatesMapper::WINDOW_SIDE_IN_PIXELS,
    resizable: false,
    background: Settings.colors.background

@apple_graphic = PerceptronSnakes::Graphics::Apple.new(
  PerceptronSnakes::Resources::Apple.new
)

@snake_graphic = PerceptronSnakes::Graphics::Snake.new(
  PerceptronSnakes::Resources::Snake.new
)

@wall_graphic = PerceptronSnakes::Graphics::Wall.new(
  PerceptronSnakes::Resources::Wall.new
)

# Controls
on :key_down do |event|
  case event.key
  when 'a'
    @snake_graphic.snake.turn_left
  when 'd'
    @snake_graphic.snake.turn_right
  end
end

# Game loop
update do
  sleep(Settings.game.base_delay)

  @snake_graphic.snake.step(@wall_graphic.wall, @apple_graphic.apple)
  @apple_graphic.update!
  @snake_graphic.update!
end

show
