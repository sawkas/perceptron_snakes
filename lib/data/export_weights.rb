# frozen_string_literal: true

module PerceptronSnakes
  module Data
    class ExportWeights
      def initialize(weights, fitness)
        @weights = weights
        @fitness = fitness
      end

      def export
        path = File.join(ROOT_DIR, 'data', filename)

        File.open(path, 'wb') { |file| file.puts JSON.pretty_generate(weights) }
      end

      private

      def filename
        "#{Time.now.to_i}_#{fitness.to_i}.txt"
      end

      attr_reader :weights, :fitness
    end
  end
end
