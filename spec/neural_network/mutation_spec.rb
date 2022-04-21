# frozen_string_literal: true

require_relative '../spec_helper'

require_relative '../../lib/gaussian_random_number_generator'
require_relative '../../lib/neural_network/mutation'

describe PerceptronSnakes::NeuralNetwork::Mutation do
  before(:all) { load_config }

  describe '#mutate' do
    subject { described_class.mutate(weights, mutation_rate) }

    let(:weights) { [[[1, 1], [1, 1], [1, 1], [1, 1], [1, 1]]] }

    context 'when mutation_rate is 0' do
      let(:mutation_rate) { 0 }

      it { expect(subject).to eq(weights) }
    end

    context 'when mutation_rate is 100' do
      let(:mutation_rate) { 100 }

      it { expect(subject).to not_eq(weights) }

      it 'deviation is correct' do
        subject[0].each_with_index do |weights_arr, i|
          weights_arr.each_with_index do |weight, j|
            diff = (weights[0][i][j] - weight).abs

            expect(diff).to be < 0.9
            expect(diff).to be > 0.00001
          end
        end
      end
    end
  end
end
