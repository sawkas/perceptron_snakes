# Perceptron snakes
Neural network and genetic algorithm try to solve snake game (Ruby 3.0.1, [ruby2d](https://github.com/ruby2d/ruby2d))

`Multilayer perceptron`, `Relu activation`, `Roulette wheel selection`, </br>
`One point crossover`, `Gaussian mutation`

<img src="https://user-images.githubusercontent.com/17087260/165080822-e050c9cf-e171-4f26-99d6-dcdf2b7c28bc.gif" width="200" height="200">

## Some explanations
```main.rb``` - the entry point, here you can see the big picture of snake training</br>
```PerceptronSnakes::NeuralNetwork::Input``` - the service class that prepares values for perceptron inputs (a.k.a. snake vision)

Currently, snakes can see in 8 directions, in every direction snakes see the distance to ```a wall```, ```an apple```, ```itself```.
Also, snakes know their ```direction``` for the next step, and ```tail direction```. So we have ```8*3+4+4=32``` values for inputs.
If you want to change snake vision, don't forget to change the number of perceptron inputs.

```PerceptronSnakes::Resources::Snake#calculate_fitness``` - there is the fitness function for snake, it shows how well the snake played.</br>
I just stole it from Chrispresso YouTube video :smiley:

```PerceptronSnakes::NeuralNetwork::WeightsStore``` - this service collects the weights of dead snakes and their fitness to provide weights for the next generation. The fitness is used to select pairs of parents to cross and get offspring. The resulting offspring weights are mutated by adding a Gaussian random number.

After application simulates all generations, the fittest snake's weights will be saved into ```data``` folder as json.
You can use it as first generation weights in next simulations (see ```learning.weights``` in configuration).

Simulation statistics for snake from the top</br>
<img src="https://user-images.githubusercontent.com/17087260/165086439-87296c9f-bdc5-41c9-8546-a776cdfbfcde.png" width="450" height="300">

## Getting Started
At first look at ```config.yml``` there are some settings for NN, GA and UI

* ```bundle install``` - to install dependencies
* ```bin/start``` - to start application

## Configuration
* ```sizes.vector``` - the snake field axis length ```(x = -N..N && y = -N..N)``` e.g. ```N = 5``` then field contains ```121``` cells
* ```sizes.cell``` - the size of cell for UI
* ```game.only_command_line_output``` - it will turn off UI for fast generation
* ```game.step_delay``` - delay between snake steps, only for UI
* ```learning.weights``` - you can specify weights for the entire 1st generation, just comment it out if you want to use random weights. (usually i use this to check in UI how my best snake behaves)
* ```learning.available_steps_without_apple``` - sometimes the snake starts to run in circles without eating apples so it will be killed after N steps
* ```learning.number_of_snakes_in_generation``` - the number of new snakes that will be generated based on parents
* ```learning.number_of_parents_in_generation``` - the number of top parents that will be included in next generation
* ```learning.number_of_generations``` - the number of generations in simulation
* ```learning.mutation_rate``` - the chance at which the weight will be mutated ```(0..100)```
* ```learning.mutation_scale``` - the gaussian random number multiplication factor for weight mutation (you can play with it)

## Tests and linter
* ```bundle exec rspec spec```
* ```bundle exec rubocop```

## Inspired by
[Chrispresso - AI Learns to play Snake!](https://youtu.be/vhiO4WsHA6c)</br>
[Piotr Białas - Implementation of artificial intelligence in Snake game](http://ceur-ws.org/Vol-2468/p9.pdf)

