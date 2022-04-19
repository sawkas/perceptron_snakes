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
  activation_function: :relu,
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
  input = PerceptronSnakes::NeuralNetwork::Input.new(
    @snake_graphic.snake, @wall_graphic.wall, @apple_graphic.apple
  ).call

  result = @perceptron.feedforward(input)

  @snake_graphic.snake.direction = PerceptronSnakes::NeuralNetwork::ResultMapper.map_result_to_direction(result)
  @snake_graphic.snake.step(@wall_graphic.wall, @apple_graphic.apple)
end

@best_score = 0
@snake_number = 0
@generation = 0
@fitneses = []

SNAKES_IN_GENERATION = 1000
NUMBER_OF_GENERATIONS = 100

@weight_store = PerceptronSnakes::NeuralNetwork::WeightsStore.new
@best_snake = { weights: nil, fitness: 0 }

new_snake

# Game loop
# loop do
update do
  sleep(Settings.game.base_delay)
  snake_step

  unless @snake_graphic.snake.alive
    fitness = @snake_graphic.snake.calculate_fitness
    @fitneses << fitness
    @best_score = @snake_graphic.snake.apples if @snake_graphic.snake.apples > @best_score

    # puts "-----------------------"
    # puts "snake: #{@snake_number}"
    # puts "generation: #{@generation}"
    # puts "fitness: #{fitness}"
    # puts "best_score: #{@best_score}"

    if @best_snake[:fitness] < fitness
      @best_snake[:fitness] = fitness
      @best_snake[:weights] = @perceptron.weights
    end

    @weight_store.add(@perceptron.weights, fitness)

    if @generation.zero?
      PerceptronSnakes::Data::ImportWeights.new(@perceptron, '1650289934_21637.txt').import
      # @perceptron.set_random_weights
    else
      @perceptron.weights = @weight_store.new_weights
    end

    if @snake_number == SNAKES_IN_GENERATION
      puts '-----------------------'
      puts "generation: #{@generation}"
      puts "avg fitness: #{@fitneses.sum / @fitneses.size.to_f}"
      puts "best_score: #{@best_score}"
      @weight_store.next_generation
      @snake_number = 0
      @generation += 1
      @fitneses = []
      @best_score = 0

      if @generation == NUMBER_OF_GENERATIONS
        PerceptronSnakes::Data::ExportWeights.new(@best_snake[:weights], @best_snake[:fitness]).export

        exit
      end
    else
      @snake_number += 1
    end

    new_snake
  end

  @apple_graphic.update!
  @snake_graphic.update!
end

show
