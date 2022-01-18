# frozen_string_literal: true

module PerceptronSnakes
  module Data
    class ImportWeights
      def initialize(perceptron, filename)
        @perceptron = perceptron
        @filename = filename
      end

      def import
        file = File.open(path).read

        perceptron.weights = JSON.parse(file)
      end

      private

      def path
        File.join(ROOT_DIR, 'data', filename)
      end

      attr_reader :perceptron, :filename
    end
  end
end
