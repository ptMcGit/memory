# memory game

require "pry"

def create_w_file(file_name)
  File.open(file_name, "a")
end

scores = create_w_file("memory_scores")

def save_scores(cards, tries, lives, result, file)
  file.write(
    "Cards: #{cards}, Tries: #{tries}, Lives: #{lives}, Result: #{result}\n"
  )
end

def print_tries(tries)
  print "Tries: "
  colorize((" " + "\u2660".encode) * tries, 32)
  print "\n"
end

def print_lives(lives)
  print "Lives: "
  colorize((" " + "\u2665".encode) * lives, 31)
  print "\n"
end

def clear_screen
  system("clear")
end

def did_win?(board, correct_guesses)
  board.map { |key, value| key } == correct_guesses.sort
end

def end_game(board)
  print "\n"
  print "Would you like to play again (y/n)? "
  until ["y","n"].include?  r = gets.chomp
    print "(y/n)? "
  end
  return r == "y"
end

def set_lives(board, difficulty)
  lives = ((board.count - (difficulty.to_f / board.count)).floor).to_i
  #lives = 6
end

def set_tries(tries_option)
  tries = 2
end

def create_grid(objects)
  (objects + objects).shuffle
end

def create_board(objects)
  # creates a square grid
  # take in objects
  # drop into dictionary with numbered
  objects = create_grid(objects)
  size = objects.length
  board = Hash[(1..size).map { |x| [x, objects.pop]}]
end

def load_data
  #["a", "b", "c", "d", "e","f"]
  ("a".."h").to_a
end

def guesses_good(board, turn_guesses)
  x = Hash[board.select { |x, y| turn_guesses.include? x }].map {|x,y| y}
  x[0] == x[1]
end

def colorize(string, color)
  print "\e[" + color.to_s + ";1m" + string + "\e[0m"
end

def print_title
  colorize("\nM e M o r y\n\n", 35)
end

def print_board(board, correct_guesses, turn_guesses)
  card_width = board.to_a.last[0].to_s.length
  count = 1

  board.map { |key, value| key }.each do |x|
    if (correct_guesses + turn_guesses).include? x
      colorize(" [ " +  (board[x].center card_width) + " ] ", 31)
    else
      print " [ ", (x.to_s.center card_width), " ] "
    end
    if count % to_be_square(board.count)  == 0
      print "\n\n"
    end
    count += 1
  end
  print "\n"
end

def to_be_square(num)
  guess = Math.sqrt(num).round
  if guess % 2 != 0
    guess += 1
  end
  guess
end


def get_valid_input(prompt, valid_input)
  print prompt
  until valid_input.include? response = gets.chomp
    print "Please enter a valid selection: "
  end
  return response
end

def array_of_nums_as_strings(num_array)
  num_array.map { |x| x.to_s }
end

def exit_program
  puts "Goodbye!"
  exit
end

def set_difficulty
  response = get_valid_input(
    "(1) Easy\n(2) Medium\n(3) Hard\n\nSelect difficulty: ",
    (1..3).to_s
  )
  return response.to_i
end



# Main program

clear_screen

while true

  # start menu stuff

  game_end = false
  wins = 0
  losses = 0

  print_title

  response = get_valid_input(
    "(1) Play (2) Options (3) Quit\n" +
    "Select an option: ",
    (1..3).to_s
  )

  difficulty = 1

  case response
  when "2"
    difficulty = set_difficulty
  when "3"
    exit_program
  end

  ### Start The Game

  until game_end

    data = load_data
    board = create_board(data)
    board_size = data.length * 2

    lives = set_lives(board, difficulty)
    correct_guesses = []

    game_over = false

    until game_over do

      turn_guesses = []
      tries = set_tries(nil)
      no_more_tries = false
      scored = false

      until no_more_tries
        clear_screen
        print_title
        print_board(board, correct_guesses, turn_guesses)
        print "\n"
        print_tries(tries)
        print_lives(lives)
        print "\n"

        if did_win?(board, correct_guesses)
          win = true
          game_over = true
          break
        elsif lives == 0
          win = false
          game_over = true
          break
        end

        if tries == 0
          if lives > 1
            print "End of turn. Press enter to continue ... "
            gets
          end
          break
        else
          response = get_valid_input(
            "What is your guess? (q to quit) ",
            ["q"] +
            array_of_nums_as_strings((1..board_size).to_a - correct_guesses - turn_guesses)
          )
        end

        if response == "q";
          game_over = true
          break
        else
          turn_guesses.push response.to_i
        end
        tries -= 1

        if guesses_good(board, turn_guesses)
          correct_guesses.concat turn_guesses
          scored = true
        end
      end

      unless scored
        lives -= 1
      end
    end

    clear_screen
    print_title
    print_board(board, (1..board_size).to_a, [])
    print "\n"

    if win
      print "Great job! You win!\n"
      wins += 1
    else
      print "You lose. Maybe next time...\n"
      losses += 1
    end

    save_scores(
      board.count,
      set_tries(difficulty),
      set_lives(board, difficulty),
      (win ? "win" : "loss"),
      scores
    )

    print "(wins: #{wins}, losses: #{losses})"

    response = get_valid_input(
      "Would you like to play again (y/n)? ",
      ["y","n"]
    )

    if response == "y"
      next
    else
      exit_program
    end
    next
  end
end
