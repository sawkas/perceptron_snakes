# frozen_string_literal: true

module PerceptronSnakes
  module NeuralNetwork
    module Functions
      class Relu
        class << self
          def call(x)
            x.positive? ? x : x * 0.01
          end
        end
      end
    end
  end
end
