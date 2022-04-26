# frozen_string_literal: true

require 'ruby2d'
require 'config'
require 'pry'
require 'matrix'
require 'json'

require_relative 'support/helpers'

include Helpers

load_config

# app
require_relative '../lib/perceptron_snakes'

# Negated matcher
RSpec::Matchers.define_negated_matcher :not_change, :change
RSpec::Matchers.define_negated_matcher :not_eq, :eq
RSpec::Matchers.define_negated_matcher :not_include, :include
