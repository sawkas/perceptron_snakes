# frozen_string_literal: true

describe PerceptronSnakes::NeuralNetwork::WeightsStore do
  let(:weights_store) { described_class.new }

  describe '#build_offspring' do
    subject { weights_store.build_offspring }

    let(:weights1) { [[[1, 1], [2, 2], [3, 3]]] }
    let(:weights2) { [[[4, 4], [5, 5], [6, 6]]] }
    let(:weights3) { [[[7, 7], [8, 8], [9, 9]]] }

    it 'builds offspring properly' do
      weights_store.add(3, weights1)
      weights_store.add(2, weights2)
      weights_store.add(1, weights3)

      weights_store.build_offspring

      offspring = weights_store.instance_variable_get('@offspring')

      expect(offspring.size).to eq(4)
      expect(offspring).to include(weights1)
      expect(offspring).to include(weights2)
    end
  end
end
