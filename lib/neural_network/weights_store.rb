# frozen_string_literal: true

module PerceptronSnakes
  module NeuralNetwork
    class WeightsStore
      MUTATION_RATE = 3

      def initialize
        @weights = {}
      end

      def add(weights, fitness)
        @weights[fitness] ||= []
        @weights[fitness] << weights
      end

      def new_weights
        crossover(get_random_weights, get_random_weights)
      end

      private

      attr_reader :weights

      def crossover(weights1, weights2, mutation_rate = MUTATION_RATE)
        weights1.map.with_index do |w1, index|
          w2 = weights2[index]

          if w1.is_a?(Array)
            crossover(w1, w2, mutation_rate)
          else
            dice = rand(1..100)

            if dice <= mutation_rate
              rand(-1.to_f..1.to_f)
            elsif (dice - mutation_rate) < ((100 - mutation_rate) / 2)
              w1
            else
              w2
            end
          end
        end
      end

      # uses roulette wheel selection
      def get_random_weights
        total_rate = weights.keys.sum
        rates = weights.keys.sort
        random_seed = rand(total_rate)

        winner = rates.each do |rate|
          break rate if random_seed <= rate

          random_seed -= rate
        end

        weights[winner].sample
      end
    end
  end
end
