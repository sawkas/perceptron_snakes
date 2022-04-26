# frozen_string_literal: true

module PerceptronSnakes
  module Utils
    class GaussianRandomNumberGenerator
      def initialize(mean = 0.0, sd = 1.0, rng = -> { Kernel.rand })
        @mean = mean
        @sd = sd
        @rng = rng
        @compute_next_pair = false
      end

      def rand
        if (@compute_next_pair = !@compute_next_pair)
          theta = 2 * Math::PI * @rng.call
          scale = @sd * Math.sqrt(-2 * Math.log(1 - @rng.call))
          @g1 = @mean + scale * Math.sin(theta)
          @g0 = @mean + scale * Math.cos(theta)
        else
          @g1
        end
      end
    end
  end
end
