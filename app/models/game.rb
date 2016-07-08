class Game
  def initialize(guess)
    start_game if game_not_started?
    @guess = guess.upcase
    @word = word
    @guess_state = guess_state
    @guesses = file[2].split(" ")
  end

  def guess_is_valid?
    @guess.
    @guess.length == 1 && @guess.match(/[a-zA-Z])
  end

  def update
    binding.pry
    if guess_is_correct?
      write_to_guess_state
    else
      @guesses << @guess
      # write_guesses_to_file
    end
  end

  def print
    <<-Hangman
    ```
    #{formatted_guesses}
    #{gallows}
    #{formatted_guess_state}
    ```
    Hangman
  end

  private

  def start_game
    File.write("game_state.txt", game_init_data)
  end

  def game_not_started?
    file.empty?
  end

  def file
    File.readlines('game_state.txt').map(&:chomp)
  end

  def word
    file[0].split("")
  end

  def guess_state
    file[1].split("")
  end

  def formatted_guesses
    "Guesses: " + file[2]
  end

  def formatted_guess_state
    file[1]
  end

  def gallows
    <<-base
    _____
       |     |
      _o_    |
       |     |
      / \\    |
    _________|___
    base
  end

  def end_game
    file.truncate(0)
  end

  def game_init_data
    [
      "CLOSURE SCOPE",
      "_ _ _ _ _ _ _  _ _ _ _ _",
      " "
    ].join("\n")
  end

  def number_of_guesses
    @guesses.length
  end

  def guess_is_correct?
    @word.include?(@guess)
  end

  def write_to_guess_state
    binding.pry
  end
end
