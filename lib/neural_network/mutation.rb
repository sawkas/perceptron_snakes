# frozen_string_literal: true

module PerceptronSnakes
  module NeuralNetwork
    class Mutation
      class << self
        def mutate(weights, mutation_rate = Settings.learning.mutation_rate)
          random_gaussian = GaussianRandomNumberGenerator.new(0.5) # mean 0.5

          weights.map do |row|
            row.map do |column|
              column.map do |value|
                dice = rand(1..100)

                if dice <= mutation_rate
                  value + random_gaussian.rand * Settings.learning.mutation_scale
                else
                  value
                end
              end
            end
          end
        end
      end
    end
  end
end
