# frozen_string_literal: true

module PerceptronSnakes
  module NeuralNetwork
    module Functions
      class Nothing
        class << self
          def call(x)
            x
          end
        end
      end
    end
  end
end
