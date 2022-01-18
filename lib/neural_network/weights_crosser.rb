# frozen_string_literal: true

# PerceptronSnakes::NeuralNetwork::WeightsCrosser.crossover([1,2,[3,4,[5,[6]]]], [7,8,[9,10,[11,[12]]]], 3)
module PerceptronSnakes
  module NeuralNetwork
    class WeightsCrosser
      class << self

        # 50% chance for each weight
        def crossover(weights1, weights2, mutation_rate)
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
      end
    end
  end
end
