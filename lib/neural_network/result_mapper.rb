# frozen_string_literal: true

module PerceptronSnakes
  module NeuralNetwork
    class ResultMapper
      class << self
        def map_result_to_direction(array)
          case array.rindex(array.max)
          when 0 then :up
          when 1 then :right
          when 2 then :down
          when 3 then :left
          end
        end
      end
    end
  end
end
