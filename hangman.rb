require 'yaml'

class Game
  def initialize
    @word_array = get_word.split("")
    @body_parts_left = 6
    @display = []
    @word_array.length.times { @display.push("_") }
    @incorrect_letters = []
  end

  def add_correct_letters(letter)
      (0..@word_array.length).each do |index| 
        if @word_array[index] == letter
          @display[index] = letter
        end
      end
  end

  def valid_guess?(letter)
    if !letter.match?(/[a-zA-Z]/) || letter.length != 1
      puts "Please enter a single letter."
      return false
    elsif @incorrect_letters.include?(letter)
      puts "You already guessed that letter, and that noose isn't getting any looser!"
      return false
    elsif @display.include?(letter)
      puts "You already got that letter, you goober!"
      return false
    else
      return true
    end
  end


  def evaluate_letter_guess(letter)
    if @word_array.include?(letter)
      add_correct_letters(letter)
    else
      @body_parts_left -= 1
      @incorrect_letters.push(letter)
      if @body_parts_left == 1
        puts "Sorry, the word does not contain an '#{letter}'! That trapdoor is looking unstable... "
      else
        puts "Sorry, the word does not contain an '#{letter}'!"
      end
    end
  end

  def show_status
    puts @display.join(" ")
    puts "Incorrect letters: #{@incorrect_letters.join(", ")}"
    puts "Body parts left: #{@body_parts_left}"
  end

  def man_dead?
    @body_parts_left == 0
  end

  def word_spelled?
    @display.none?("_")
  end

  def reveal_word
    @word_array.join("")
  end

  def get_word
    dictionary = File.readlines("5desk.txt")
    eligible_words = dictionary.select {|word| word.length > 4 && word.length < 13}
    eligible_words.sample.downcase.chomp
  end
end

def examine(input, game)
  if input == "exit"
    exit
  elsif input == "save"
    save(game)
    exit
  end
end


def play_round(game)
  puts ""
  puts "Enter a letter:"
  letter = gets.chomp.downcase
  examine(letter, game)

  until game.valid_guess?(letter) do
    puts "Enter a letter:"
    letter = gets.chomp.downcase
  end

  game.evaluate_letter_guess(letter)
  game.show_status
end

def play(game)
  puts ""
  game.show_status


  until game.man_dead? || game.word_spelled? do
    play_round(game)
  end

  if game.man_dead?
    puts ""
    puts "Oh. That's ... gruesome"
    puts ""
    puts ""
    puts ""
    puts ""
    puts "Oh, yeah. The word was '#{game.reveal_word}'"
  elsif game.word_spelled?
    puts "Congratulations! It seems there was a gubernatorial pardon."
  end

  puts "Another game?"
  another_game
end

def start_playing
  input = gets.chomp
  if input == 'new'
    game = Game.new
    play(game)
  elsif input == 'old'
    puts "Which game do you want to open?"
    play(retrieve_game)
  elsif input == 'exit'
    exit
  else
    puts "Please enter 'old' or 'new'"
    start_game
  end
end


def save(game)
  dump = game.to_yaml
  puts "Give your game a name:"
  filename = "saved-games/#{gets.chomp}.yaml"
  File.open(filename, "w") do |file|
    file.puts dump
  end
end

def retrieve_game
  game_name = gets.chomp
  file_name = "saved-games/#{game_name}.yaml"
  if File.exist? (file_name)
    dump = File.open(file_name, "r")
    YAML.load(dump)
  elsif game_name == "exit"
    exit
  else
    puts "Please enter a valid game name"
    retrieve_game()
  end
end

def another_game
  answer = gets.chomp
  if answer == "yes"
    puts "Enter 'new' to begin a new game. Enter 'old' to open a previously saved game."
    start_playing
  elsif answer == "no"
    puts "Bye for now."
    exit
  else
    puts "Please enter 'yes' or 'no'"
    another_game
  end
end

puts "Welcome to Hangman!"
puts "At any time, enter 'exit' to exit the game, or 'save' to save the game and come back later."
puts "Enter 'new' to begin a new game. Enter 'old' to open a previously saved game."

start_playing

  


