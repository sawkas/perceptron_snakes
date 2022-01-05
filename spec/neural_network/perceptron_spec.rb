require 'rspec'
require_relative '../../lib/neural_network/perceptron'
require_relative '../../lib/neural_network/functions/sigmoid'
require_relative '../../lib/neural_network/functions/nothing'

describe PerceptronSnakes::NeuralNetwork::Perceptron do
  let(:perceptron) do
    described_class.new(
      number_of_inputs: number_of_inputs,
      number_of_outputs: number_of_outputs,
      number_of_nodes_on_hidden: number_of_nodes_on_hidden,
      activation_function: activation_function,
      bias: bias
    )
  end

  let(:activation_function) { :nothing }
  let(:bias) { false }

  describe '#feedforward' do
    subject { perceptron.feedforward(input) }

    context 'with specific weights' do
      before { perceptron.weights = weights }

      context 'without hidden layers & single output' do
        let(:number_of_inputs) { 2 }
        let(:number_of_outputs) { 1 }
        let(:number_of_nodes_on_hidden) { [] }
        let(:weights) { [[[0.5], [0.7]]] }
        let(:input) { [2, 4] }

        it { is_expected.to eq([3.8]) }
      end

      context 'without hidden layers & double output' do
        let(:number_of_inputs) { 3 }
        let(:number_of_outputs) { 2 }
        let(:number_of_nodes_on_hidden) { [] }
        let(:weights) { [[[1, 2], [3, 4], [5, 6]]] }
        let(:input) { [1, 2, 3] }

        it { is_expected.to eq([22, 28]) }
      end

      context 'with hidden layers' do
        let(:number_of_inputs) { 3 }
        let(:number_of_outputs) { 1 }
        let(:number_of_nodes_on_hidden) { [2] }
        let(:weights) { [[[1, 2], [3, 4], [5, 6]], [[7], [8]]] }
        let(:input) { [1, 2, 3] }

        it { is_expected.to eq([378]) }
      end

      context 'with hidden layers and activation_function' do
        let(:number_of_inputs) { 3 }
        let(:number_of_outputs) { 1 }
        let(:number_of_nodes_on_hidden) { [2] }
        let(:weights) { [[[1, 2], [3, 4], [5, 6]], [[7], [8]]] }
        let(:input) { [1, 2, 3] }
        let(:activation_function) { :sigmoid }

        it { is_expected.to eq([0.9999996940977726]) }
      end

      context 'with hidden layers and bias' do
        let(:number_of_inputs) { 3 }
        let(:number_of_outputs) { 1 }
        let(:number_of_nodes_on_hidden) { [2] }
        let(:weights) { [[[1, 2], [3, 4], [5, 6], [7, 8]], [[9], [10], [11]]] }
        let(:input) { [1, 2, 3] }
        let(:bias) { true }

        it { is_expected.to eq([821]) }
      end
    end
  end
end
