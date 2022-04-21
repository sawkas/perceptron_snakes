# frozen_string_literal: true

require_relative '../spec_helper'

require_relative '../../lib/neural_network/roulette_wheel'

describe PerceptronSnakes::NeuralNetwork::RouletteWheel do
  describe '#get_random' do
    subject { described_class.new(fitness_hash).get_random }

    context 'whenfitness_hash contain only one value' do
      let(:fitness_hash) do
        { 10 => [[10]] }
      end

      it { is_expected.to eq([10]) }
    end

    context 'when fitness_hash contain many values' do
      let(:fitness_hash) do
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
        roulette_wheel = described_class.new(fitness_hash)

        1000.times do
          val = roulette_wheel.get_random.first
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
end
