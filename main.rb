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

def log_variables
  str = ''
  str += "-----------------------\n"
  str += "generation: #{@generation}: "
  str += "best_score: #{@scores.max}; "
  str += "avg fitness: #{@fitneses.sum / @fitneses.size}; "
  str += "avg score: #{(@scores.sum.to_f / @scores.size).round(2)}"
  puts str
end

@generation = 0
@snake_number = 0
@scores = []
@fitneses = []
@best_snake = { weights: nil, fitness: 0 }

@weight_store = PerceptronSnakes::NeuralNetwork::WeightsStore.new
new_snake

main_iteration =
  proc do
    snake_step

    unless @snake_graphic.snake.alive
      fitness = @snake_graphic.snake.calculate_fitness

      @fitneses << fitness
      @scores << @snake_graphic.snake.apples
      if @best_snake[:fitness] < fitness
        @best_snake[:fitness] = fitness
        @best_snake[:weights] = @perceptron.weights
      end

      @weight_store.add(fitness, @perceptron.weights)

      if @generation.zero?
        if Settings.learning.weights
          PerceptronSnakes::Data::ImportWeights.new(@perceptron, Settings.learning.weights).import
        else
          @perceptron.set_random_weights
        end
      else
        @perceptron.weights = @weight_store.get_offspring_weights
      end

      if @snake_number == Settings.learning.number_of_snakes_in_generation
        log_variables

        @weight_store.build_offspring
        @snake_number = 0
        @generation += 1
        @fitneses = []
        @scores = []

        if @generation == Settings.learning.number_of_generations
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

if Settings.game.only_command_line_output
  loop { main_iteration.call }
else
  update do
    sleep(Settings.game.step_delay)

    main_iteration.call
  end
end

show
