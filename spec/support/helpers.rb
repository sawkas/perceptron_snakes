# frozen_string_literal: true

module Helpers
  def load_config
    Config.load_and_set_settings(File.expand_path('spec/support/test_config.yml'))
  end

  def build_snake(coordinates)
    s = PerceptronSnakes::Resources::Snake.new
    body = coordinates.map { |x, y| PerceptronSnakes::Resources::Snake::BodyCell.new(x, y) }
    s.instance_variable_set(:@body, body)
    s
  end
end
