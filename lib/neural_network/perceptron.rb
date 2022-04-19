# frozen_string_literal: true

module PerceptronSnakes
  module NeuralNetwork
    class Perceptron
      attr_accessor :weights

      def initialize(
        number_of_inputs:,
        number_of_outputs:,
        number_of_nodes_on_hidden: [],
        activation_function: :nothing,
        bias: false
      )
        @number_of_inputs = number_of_inputs
        @number_of_outputs = number_of_outputs
        @nodes_on_each_layer = [number_of_inputs, number_of_nodes_on_hidden, number_of_outputs].flatten
        @bias = bias
        @activation_function =
          Object.const_get("PerceptronSnakes::NeuralNetwork::Functions::#{activation_function.capitalize}")
      end

      def feedforward(inputs)
        weights.inject(inputs) do |memo, layer_weights|
          calculate_layer(memo, layer_weights)
        end
      end

      def set_random_weights
        @weights = []

        nodes_on_each_layer.each_cons(2).with_index do |(prev_nodes, next_nodes), layer|
          prev_nodes += 1 if bias
          @weights[layer] = Array.new(prev_nodes, [])

          prev_nodes.times do |node|
            @weights[layer][node] = next_nodes.times.map { rand(-1.to_f..1.to_f) }
          end
        end
      end

      private

      attr_reader :number_of_inputs, :number_of_outputs, :nodes_on_each_layer, :activation_function, :bias

      # inputs: [1, 2, 3]
      # weights: [[1, 2], [3, 4], [5, 6]]
      # returns: [22, 28]
      def calculate_layer(inputs, layer_weights)
        inputs.unshift(1) if bias

        multiply_matrices([inputs], layer_weights).to_a.flatten.map { |o| activation_function.call(o) }
      end

      def multiply_matrices(a, b)
        Matrix[*a] * Matrix[*b]
      end
    end
  end
end
