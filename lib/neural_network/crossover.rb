# frozen_string_literal: true

module PerceptronSnakes
  module NeuralNetwork
    class Crossover
      class << self
        # One-point crossover
        def crossover(weights1, weights2)
          point = rand(0..(weights1.size - 1))

          if [true, false].sample
            buff = weights1
            weights1 = weights2
            weights2 = buff
          end

          weights1.each_with_index.map do |sub_weights1, index|
            sub_weights2 = weights2[index]

            sub_weights1[0..point] + sub_weights2[(point + 1)..]
          end
        end
      end
    end
  end
end
