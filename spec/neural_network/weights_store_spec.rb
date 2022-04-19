# frozen_string_literal: true

require_relative '../spec_helper'

require_relative '../../lib/gaussian_random_number_generator'
require_relative '../../lib/neural_network/weights_store'

describe PerceptronSnakes::NeuralNetwork::WeightsStore do
  let(:weights_store) { described_class.new }

  before(:all) { load_config }

  describe '#get_random_weights' do
    subject { weights_store.send(:get_random_weights) }

    before(:each) do
      weights_store.instance_variable_set(:@weights, weights)
    end

    context 'when weights contain only one value' do
      let(:weights) do
        { 10 => [[10]] }
      end

      it { is_expected.to eq([10]) }
    end

    context 'when weights contain many values' do
      let(:weights) do
        {
          1 => [[1]],
          2 => [[2]],
          3 => [[3]],
          4 => [[4]],
          5 => [[5]],
          6 => [[6]]
        }
      end

      it 'correct distribution' do
        results = {}

        1000.times do
          val = weights_store.send(:get_random_weights).first
          results[val] ||= 0
          results[val] += 1
        end

        expect(results[1]).to be < 125
        expect(results[2]).to be < 150
        expect(results[3]).to be < 175
        expect(results[4]).to be > 150
        expect(results[5]).to be > 175
        expect(results[6]).to be > 200
      end
    end
  end

  describe '#crossover' do
    subject { weights_store.send(:crossover, weights1, weights2, mutation_rate) }

    let(:weights1) { [[[1, 2], [3, 4], [5, 6], [7, 8], [9, 10]]] }
    let(:weights2) { [[[11, 12], [13, 14], [15, 16], [17, 18], [19, 20]]] }

    context 'when mutation_rate is 0' do
      let(:mutation_rate) { 0 }

      it 'every weight relates to weights1 or weights1' do
        subject.each_with_index do |weights, i|
          weights.each_with_index do |weight, j|
            expect(weight).to eq(weights1[i][j]).or eq(weights2[i][j])
          end
        end
      end
    end

    context 'when mutation_rate is 100' do
      let(:mutation_rate) { 100 }

      it 'every weight related to weights1 or weights1' do
        subject.each_with_index do |weights, i|
          weights.each_with_index do |weight, j|
            expect(weight).to not_eq(weights1[i][j]).and not_eq(weights2[i][j])
          end
        end
      end
    end
  end

  describe '#add' do
    subject(:add_weights) { weights_store.add([1, 2, 3], 1) }

    let(:next_generation_weights) do
      { 1 => [[1, 2, 3]] }
    end

    it 'next_generation_weights has changed' do
      expect { add_weights }
        .to change { weights_store.send(:next_generation_weights) }.to(next_generation_weights)
        .and not_change { weights_store.send(:weights) }
    end

    context 'when some weights had been added' do
      let(:next_generation_weights) do
        { 1 => [[1, 1, 1], [1, 2, 3]] }
      end

      before do
        weights_store.instance_variable_set(:@next_generation_weights, { 1 => [[1, 1, 1]] })
      end

      it 'next_generation_weights has changed' do
        expect { add_weights }
          .to change { weights_store.send(:next_generation_weights) }.to(next_generation_weights)
          .and not_change { weights_store.send(:weights) }
      end
    end
  end
end
