# frozen_string_literal: true

require 'pry'
require 'rspec'
require 'matrix'
require 'config'

require_relative 'support/helpers'

include Helpers

RSpec::Matchers.define_negated_matcher :not_change, :change
RSpec::Matchers.define_negated_matcher :not_eq, :eq
