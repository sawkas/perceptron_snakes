# frozen_string_literal: true

def run_simulation_without_graphics(simulation)
  loop { simulation.iteration }
end

def run_simulation_with_graphics(simulation)
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
end

simulation = PerceptronSnakes::Simulation.new

if Settings.game.only_command_line_output
  run_simulation_without_graphics(simulation)
else
  run_simulation_with_graphics(simulation)
end
