# frozen_string_literal: true

module PerceptronSnakes
  ROOT_DIR = File.join(File.dirname(__FILE__), '..')

  # utils
  require_relative 'utils/coordinates_mapper'
  require_relative 'utils/gaussian_random_number_generator'

  # resources
  require_relative 'resources/concerns/updatable'
  require_relative 'resources/apple'
  require_relative 'resources/wall'
  require_relative 'resources/snake'

  # graphics
  require_relative 'graphics/apple'
  require_relative 'graphics/snake'
  require_relative 'graphics/wall'

  # NN
  require_relative 'neural_network/input'
  require_relative 'neural_network/perceptron'
  require_relative 'neural_network/result_mapper'
  require_relative 'neural_network/roulette_wheel'
  require_relative 'neural_network/crossover'
  require_relative 'neural_network/mutation'
  require_relative 'neural_network/weights_store'

  # functions
  require_relative 'neural_network/functions/nothing'
  require_relative 'neural_network/functions/sigmoid'
  require_relative 'neural_network/functions/relu'

  # export/import
  require_relative 'data/export_weights'
  require_relative 'data/import_weights'

  # simulation
  require_relative 'simulation'
end
