class Game
  def initialize(guess = nil)
    start_game if game_not_started?
    @guess = guess ? guess[0].upcase : nil
    @word = word_array
    @guess_state = guess_state_array
    @wrong_guesses = wrong_guesses_array
  end

  def self.start_round(guess)
    self.new(guess)
  end

  def guess_is_valid?
    @guess.length == 1 && @guess.match(/[a-zA-Z]/)
  end

  def update
    if guess_is_correct?
      write_to_guess_state
    else
      write_to_wrong_guesses
    end
  end

  def draw
    return win_message if game_won?
    return lose_message if game_lost?
    <<-Hangman
    ```
    Guesses: #{wrong_guesses_from_file}
    #{gallows}
    #{guess_state_from_file}
    ```
    Hangman
  end

  private

  def start_game
    File.write(file_name, game_init_data)
  end

  def game_not_started?
    file.empty?
  end

  def game_won?
    if file[0] == file[1]
      File.truncate(file_name, 0)
      return true
    end
    false
  end

  def game_lost?
    number_of_wrong_guesses >= 6
  end

  def win_message
    "Solved! `#{@guess_state.join(" ")}`"
  end

  def word_array
    file[0].split("")
  end

  def word_string
    word_array.join("")
  end

  def guess_state_array
    file[1].split("")
  end

  def guess_state
    guess_state_array.join("")
  end

  def wrong_guesses_array
    file[2] ? file[2].split(" ") : []
  end

  def guesses
    wrong_guesses_array.join(" ")
  end

  def wrong_guesses_from_file
    file[2]
  end

  def guess_state_from_file
    file[1].split("").join(" ")
  end

  def gallows
    File
      .read("gallows.txt")
      .split("BREAK")
      .find
      .with_index { |_, i| number_of_wrong_guesses == i }
  end

  def end_game
    File.open(file_name, 'w').truncate(0)
    @game_over = true
  end

  def game_init_data
    [
      "CLOSURE SCOPE",
      "_______ _____"
    ].join("\n")
  end

  def number_of_wrong_guesses
    @wrong_guesses.length
  end

  def guess_is_correct?
    @word.include?(@guess)
  end

  def write_to_wrong_guesses
    new_file = file
    new_file[2] = next_wrong_guesses.join(" ")
    write_to_file(new_file)
  end

  def next_wrong_guesses
    @wrong_guesses.push(@guess)
  end

  def next_guess_state
    update_char = -> (char, i) { @word[i] == @guess ? @guess : char }
    @guess_state = @guess_state
      .map
      .with_index(&update_char)
  end

  def write_to_guess_state
    new_file = file
    new_file[1] = next_guess_state.join("")
    write_to_file(new_file)
  end

  def write_to_file(new_file_contents)
    File.open(file_name, 'w') { |f| f.write(new_file_contents.join("\n")) }
  end

  def file
    File.readlines(file_name).map(&:chomp)
  end

  def file_name
    'game_state.txt'
  end
end
