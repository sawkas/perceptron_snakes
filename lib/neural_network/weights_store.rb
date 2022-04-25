# frozen_string_literal: true

module PerceptronSnakes
  module NeuralNetwork
    class WeightsStore
      def initialize
        @parents = []
        @offspring = []
      end

      def add(fitness, weights)
        @parents << { fitness: fitness, weights: weights }
      end

      def get_offspring_weights
        @offspring.pop
      end

      def build_offspring
        rw = RouletteWheel.new(fitness_hash)

        Settings.learning.number_of_snakes_in_generation.times do
          child = Crossover.crossover(rw.get_random, rw.get_random)

          @offspring << Mutation.mutate(child)
        end

        # add top N parents to the offspring
        n = Settings.learning.number_of_parents_in_generation
        @offspring += @parents.sort_by { |w| w[:fitness] }.last(n).map { |w| w[:weights] }

        @parents = []
      end

      private

      attr_reader :parents

      def fitness_hash
        # TODO: use uniq key for each weight
        parents.each_with_object({}) do |parent, memo|
          memo[parent[:fitness]] ||= []
          memo[parent[:fitness]] << parent[:weights]
        end
      end
    end
  end
end
