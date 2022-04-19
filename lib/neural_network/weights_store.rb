# frozen_string_literal: true

module PerceptronSnakes
  module NeuralNetwork
    class WeightsStore
      MUTATION_RATE = 5

      def initialize
        @weights = {}
        @next_generation_weights = {}
      end

      def add(weights, fitness)
        @next_generation_weights[fitness] ||= []
        @next_generation_weights[fitness] << weights
      end

      def new_weights
        crossover(get_random_weights, get_random_weights)
      end

      def next_generation
        @weights = next_generation_weights
        @next_generation_weights = {}
      end

      private

      attr_reader :weights, :next_generation_weights

      # Simulated Binary Crossover
      # def crossover(weights1, weights2, mutation_rate = MUTATION_RATE)
      #   weights1.map.with_index do |w1, index|
      #     w2 = weights2[index]

      #     if w1.is_a?(Array)
      #       crossover(w1, w2, mutation_rate)
      #     else
      #       dice = rand(1..100)

      #       if dice <= mutation_rate
      #         rand(-1.to_f..1.to_f)
      #       elsif (dice - mutation_rate) < ((100 - mutation_rate) / 2)
      #         w1
      #       else
      #         w2
      #       end
      #     end
      #   end
      # end

      # Single Point Binary Crossover
      def crossover(weights1, weights2, mutation_rate = MUTATION_RATE)
        point = rand(0..(weights1.size - 1))

        if [true, false].sample
          buff = weights1
          weights1 = weights2
          weights2 = buff
        end

        res = weights1.each_with_index.map do |sub_weights1, index|
          sub_weights2 = weights2[index]

          sub_weights1[0..point] + sub_weights2[(point + 1)..]
        end

        random_gaussian = GaussianRandomNumberGenerator.new(0.5)

        res.map do |row|
          row.map do |column|
            column.map do |value|
              dice = rand(1..100)

              if dice <= mutation_rate
                value + random_gaussian.rand * 0.2
              else
                value
              end
            end
          end
        end
      end

      # Roulette wheel selection
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
