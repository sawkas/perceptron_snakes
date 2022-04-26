# frozen_string_literal: true

describe PerceptronSnakes::NeuralNetwork::Input do
  let(:input) { described_class.new(snake, wall, apple) }
  let(:snake) { build_snake(snake_coordinates) }
  let(:wall) { PerceptronSnakes::Resources::Wall.new }
  let(:apple) { PerceptronSnakes::Resources::Apple.new(snake) }
  let(:apple_coordinates) { { x: 4, y: 4 } }

  before(:each) do
    apple.instance_variable_set(:@x, apple_coordinates[:x])
    apple.instance_variable_set(:@y, apple_coordinates[:y])
  end

  describe '#vision' do
    subject { input.send(:vision) }

    context 'when 3 cells snake moves down and apple on the right side' do
      let(:snake_coordinates) { [[1, -2], [1, -1], [1, 0], [0, 0]] }
      let(:apple_coordinates) { { x: 4, y: -2 } }

      # w w w w w Y w w w w w
      # w . . . . + . . . . w
      # w . . . . + . . . . w
      # w . . . . + . . . . w
      # w . . . . + . . . . w
      # + + + + + S S + + + X
      # w . . . . + S . . . w
      # w . . . . + H . . A w
      # w . . . . + . . . . w
      # w . . . . + . . . . w
      # w w w w w + w w w w w

      let(:distance_to_wall) do
        [
          0.14285714285714285,
          0.25,
          0.25,
          0.3333333333333333,
          0.3333333333333333,
          0.3333333333333333,
          0.16666666666666666,
          0.16666666666666666
        ]
      end

      let(:distance_to_apple) do
        [
          0.0,
          0.0,
          0.3333333333333333,
          0.0,
          0.0,
          0.0,
          0.0,
          0.0
        ]
      end

      let(:distance_to_snake) do
        [
          1.0,
          0.0,
          0.0,
          0.0,
          0.0,
          0.0,
          0.0,
          0.0
        ]
      end

      let(:vision) do
        (0..7).map { |i| [distance_to_wall[i], distance_to_apple[i], distance_to_snake[i]] }.flatten
      end

      it { is_expected.to eq(vision) }
    end
  end

  describe '#tail_direction' do
    subject { input.send(:tail_direction) }

    context 'when tail_direction is up' do
      let(:snake_coordinates) { [[0, 1], [0, 0]] }

      it { is_expected.to eq([1, 0, 0, 0]) }
    end

    context 'when tail_direction is down' do
      let(:snake_coordinates) { [[0, -1], [0, 0]] }

      it { is_expected.to eq([0, 1, 0, 0]) }
    end

    context 'when tail_direction is left' do
      let(:snake_coordinates) { [[-1, 0], [0, 0]] }

      it { is_expected.to eq([0, 0, 1, 0]) }
    end

    context 'when tail_direction is right' do
      let(:snake_coordinates) { [[1, 0], [0, 0]] }

      it { is_expected.to eq([0, 0, 0, 1]) }
    end
  end

  describe 'Coordinates' do
    let(:snake_coordinates) { [[1, -2], [1, -1], [1, 0], [0, 0]] }

    # w w w w w Y w w w w w
    # w . . . . + . . . . w
    # w . . . . + . . . . w
    # w . . . . + . . . . w
    # w . . . . + . . . . w
    # + + + + + S S + + + X
    # w . . . . + S . . . w
    # w . . . . + H . . . w
    # w . . . . + . . . . w
    # w . . . . + . . . . w
    # w w w w w + w w w w w

    describe '#v1_coordinates' do
      subject { input.send(:v1_coordinates) }

      it { is_expected.to eq([[1, -1], [1, 0], [1, 1], [1, 2], [1, 3], [1, 4], [1, 5]]) }
    end

    describe '#v2_coordinates' do
      subject { input.send(:v2_coordinates) }

      it { is_expected.to eq([[2, -1], [3, 0], [4, 1], [5, 2]]) }
    end

    describe '#v3_coordinates' do
      subject { input.send(:v3_coordinates) }

      it { is_expected.to eq([[2, -2], [3, -2], [4, -2], [5, -2]]) }
    end

    describe '#v4_coordinates' do
      subject { input.send(:v4_coordinates) }

      it { is_expected.to eq([[2, -3], [3, -4], [4, -5]]) }
    end

    describe '#v5_coordinates' do
      subject { input.send(:v5_coordinates) }

      it { is_expected.to eq([[1, -3], [1, -4], [1, -5]]) }
    end

    describe '#v6_coordinates' do
      subject { input.send(:v6_coordinates) }

      it { is_expected.to eq([[0, -3], [-1, -4], [-2, -5]]) }
    end

    describe '#v7_coordinates' do
      subject { input.send(:v7_coordinates) }

      it { is_expected.to eq([[0, -2], [-1, -2], [-2, -2], [-3, -2], [-4, -2], [-5, -2]]) }
    end

    describe '#v8_coordinates' do
      subject { input.send(:v8_coordinates) }

      it { is_expected.to eq([[0, -1], [-1, 0], [-2, 1], [-3, 2], [-4, 3], [-5, 4]]) }
    end
  end
end
