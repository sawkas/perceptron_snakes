# frozen_string_literal: true

module PerceptronSnakes
  module NeuralNetwork
    class RouletteWheel
      # fitness_hash => { fitness1: weights1, fitness2: weights2 }
      def initialize(fitness_hash)
        @fitness_hash = fitness_hash
      end

      def get_random
        total_rate = fitness_hash.keys.sum
        rates = fitness_hash.keys.sort
        random_seed = rand(total_rate)

        winner = rates.each do |rate|
          break rate if random_seed <= rate

          random_seed -= rate
        end

        fitness_hash[winner].sample
      end

      private

      attr_reader :fitness_hash
    end
  end
end
