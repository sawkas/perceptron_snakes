# frozen_string_literal: true

module PerceptronSnakes
  class Simulation
    def initialize
      build_new_resources

      @generation = 0
      @snake_number = 0
      @generation_scores = []
      @generation_fitneses = []
      @best_snake = { weights: nil, fitness: 0 }
    end

    def iteration
      snake_step

      unless @snake.alive
        collect_snake
        set_perceptron_weights

        if snake_number == Settings.learning.number_of_snakes_in_generation
          log_variables

          if generation == Settings.learning.number_of_generations
            Data::ExportWeights.new(@best_snake[:weights], @best_snake[:fitness]).export

            exit
          end

          start_new_generation
        else
          @snake_number += 1
        end

        build_new_resources
      end

      update_graphics!
    end

    private

    # resources
    attr_reader :wall, :snake, :apple, :wall_graphic, :snake_graphic, :apple_graphic

    # other vars
    attr_reader :snake_number, :generation, :generation_fitneses, :generation_scores

    def log_variables
      str = "----------------------------------------------------------------------------\n"
      str += "generation: #{generation.to_s.rjust(4, '0')}: "
      str += "best_score: #{generation_scores.max.to_s.rjust(2, '0')}; "
      str += "avg fitness: #{(generation_fitneses.sum / generation_fitneses.size).round(2)}; "
      str += "avg score: #{(generation_scores.sum.to_f / generation_scores.size).round(2)}"

      puts str
    end

    def start_new_generation
      weight_store.build_offspring
      @snake_number = 0
      @generation += 1
      @generation_fitneses = []
      @generation_scores = []
    end

    def set_perceptron_weights
      if generation.zero?
        if Settings.learning.weights
          Data::ImportWeights.new(perceptron, Settings.learning.weights).import
        else
          perceptron.set_random_weights
        end
      else
        perceptron.weights = weight_store.get_offspring_weights
      end
    end

    def collect_snake
      fitness = @snake.calculate_fitness

      @generation_fitneses << fitness
      @generation_scores << @snake.apples

      if @best_snake[:fitness] < fitness
        @best_snake[:fitness] = fitness
        @best_snake[:weights] = perceptron.weights
      end

      weight_store.add(fitness, perceptron.weights)
    end

    def weight_store
      @weight_store ||= NeuralNetwork::WeightsStore.new
    end

    def snake_step
      @snake.direction = choose_new_direction
      @snake.step(@wall, @apple)
    end

    def choose_new_direction
      input = NeuralNetwork::Input.new(@snake, @wall, @apple).call
      output = perceptron.feedforward(input)

      NeuralNetwork::ResultMapper.map_result_to_direction(output)
    end

    def build_new_resources
      @wall = Resources::Wall.new
      @snake = Resources::Snake.new
      @apple = Resources::Apple.new(@snake)

      return if Settings.game.only_command_line_output

      clear_graphics if @snake_graphic || @apple_graphic

      @wall_graphic = Graphics::Wall.new(@wall)
      @snake_graphic = Graphics::Snake.new(@snake)
      @apple_graphic = Graphics::Apple.new(@apple)
    end

    def update_graphics!
      return if Settings.game.only_command_line_output

      @apple_graphic.update!
      @snake_graphic.update!
    end

    def clear_graphics
      return if Settings.game.only_command_line_output

      @snake_graphic.remove
      @apple_graphic.remove
    end

    def perceptron
      return @perceptron if @perceptron

      @perceptron =
        NeuralNetwork::Perceptron.new(
          number_of_inputs: 32,
          number_of_outputs: 4,
          number_of_nodes_on_hidden: [20, 12],
          activation_function: :relu,
          bias: true
        )

      @perceptron.set_random_weights
      @perceptron
    end
  end
end
