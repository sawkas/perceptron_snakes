# frozen_string_literal: true

require_relative '../spec_helper'

require_relative '../../lib/neural_network/crossover'

describe PerceptronSnakes::NeuralNetwork::Crossover do
  describe '#crossover' do
    subject { described_class.crossover(weights1, weights2) }

    let(:weights1) { [[[1, 2], [3, 4], [5, 6], [7, 8], [9, 10]]] }
    let(:weights2) { [[[11, 12], [13, 14], [15, 16], [17, 18], [19, 20]]] }

    it 'every weight relates to weights1 or weights1' do
      subject.each_with_index do |weights, i|
        weights.each_with_index do |weight, j|
          expect(weight).to eq(weights1[i][j]).or eq(weights2[i][j])
        end
      end
    end
  end
end
