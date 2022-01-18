# frozen_string_literal: true

set title: 'PerceptronSnakes',
    width: PerceptronSnakes::CoordinatesMapper::WINDOW_SIDE_IN_PIXELS,
    height: PerceptronSnakes::CoordinatesMapper::WINDOW_SIDE_IN_PIXELS,
    resizable: false,
    background: Settings.colors.background

@wall_graphic = PerceptronSnakes::Graphics::Wall.new(
  PerceptronSnakes::Resources::Wall.new
)

@perceptron = PerceptronSnakes::NeuralNetwork::Perceptron.new(
  number_of_inputs: 32,
  number_of_outputs: 4,
  number_of_nodes_on_hidden: [20, 12],
  activation_function: :sigmoid,
  bias: true
)

@perceptron.set_random_weights

def new_snake
  if @snake_graphic && @apple_graphic
    @snake_graphic.remove
    @apple_graphic.remove
  end

  @snake_graphic = PerceptronSnakes::Graphics::Snake.new(
    PerceptronSnakes::Resources::Snake.new
  )

  @apple_graphic = PerceptronSnakes::Graphics::Apple.new(
    PerceptronSnakes::Resources::Apple.new(@snake_graphic.snake)
  )
end

def snake_step
  input = PerceptronSnakes::NeuralNetwork::Input.new(@snake_graphic.snake, @wall_graphic.wall,
                                                     @apple_graphic.apple).call
  result = @perceptron.feedforward(input)

  puts "fitness: #{@snake_graphic.snake.calculate_fitness}"

  direction = PerceptronSnakes::NeuralNetwork::ResultMapper.map_result_to_direction(result)
  @snake_graphic.snake.direction = direction
  @snake_graphic.snake.step(@wall_graphic.wall, @apple_graphic.apple)
end

@snake_number = 0

new_snake

# Game loop
update do
  # sleep(Settings.game.base_delay)
  snake_step

  unless @snake_graphic.snake.alive
    @snake_number += 1
    @perceptron.set_random_weights
    new_snake

    binding.pry if @snake_number == 100
  end

  @apple_graphic.update!
  @snake_graphic.update!
end

# Controls
# on :key_down do |event|
#   case event.key
#   when 'r'
#     new_snake
#   when 's'
#     snake_step
#   end
# end

show

# @squares = []
# def draw_coordinates(coordinates, color)
#   coordinates.map do |x, y|
#     @squares << Square.new(PerceptronSnakes::CoordinatesMapper.map_cell_to_square(x, y).merge({ color: color }))
#   end
# end

# input = PerceptronSnakes::NeuralNetwork::Input.new(@snake_graphic.snake, @wall_graphic.wall, @apple_graphic.apple)

# draw_coordinates(input.v1_coordinates, 'red')
# draw_coordinates(input.v2_coordinates, 'green')
# draw_coordinates(input.v3_coordinates, 'blue')
# draw_coordinates(input.v4_coordinates, 'yellow')
# draw_coordinates(input.v5_coordinates, 'red')
# draw_coordinates(input.v6_coordinates, 'green')
# draw_coordinates(input.v7_coordinates, 'blue')
# draw_coordinates(input.v8_coordinates, 'yellow')
