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
    if @incorrect_letters.include?(letter)
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
      puts "Sorry, the word does not contain an '#{letter}'! That trapdoor is looking unstable... "
      @body_parts_left -= 1
      @incorrect_letters.push(letter)
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
end

def get_word
  dictionary = File.readlines("5desk.txt")
  eligible_words = dictionary.select {|word| word.length > 4 && word.length < 13}
  eligible_words.sample.downcase.chomp
end

def play_round(game)
  puts ""
  puts "Enter a letter:"
  letter = gets.chomp.downcase

  until game.valid_guess?(letter) do
    puts "Enter a letter:"
    letter = gets.chomp.downcase
  end

  game.evaluate_letter_guess(letter)
  game.show_status
end

puts "Welcome to Hangman!"

game = Game.new
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
