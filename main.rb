# frozen_string_literal: true

simulation = PerceptronSnakes::Simulation.new

loop { simulation.iteration } if Settings.game.only_command_line_output

set title: 'PerceptronSnakes',
    width: PerceptronSnakes::Utils::CoordinatesMapper::WINDOW_SIDE_IN_PIXELS,
    height: PerceptronSnakes::Utils::CoordinatesMapper::WINDOW_SIDE_IN_PIXELS,
    resizable: false,
    background: Settings.colors.background

update do
  sleep(Settings.game.step_delay)

  simulation.iteration
end

show
