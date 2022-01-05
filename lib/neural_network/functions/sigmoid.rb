# frozen_string_literal: true

module PerceptronSnakes
  module NeuralNetwork
    module Functions
      class Sigmoid
        class << self
          def call(x)
            1.0 / (1 + Math.exp(-x))
          end
        end
      end
    end
  end
end
