# frozen_string_literal: true

module PerceptronSnakes
  module NeuralNetwork
    class ResultMapper
      class << self
        def map_result_to_direction(array)
          case array.index(array.max)
          when 0 then :up
          when 1 then :down
          when 2 then :left
          when 3 then :right
          end
        end
      end
    end
  end
end
