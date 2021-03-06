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
  lives = (board.count / 2 - ((difficulty - 1) * 2)).to_i
  #lives = ((board.count - ((difficulty.to_f / board.count)).floor) - difficulty).to_i
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

def load_data(size)
  ("A".."Z").to_a.slice 0, size
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
  card_width = board.flatten.max_by { |x| x.to_s.length }.to_s.length
  binding.pry
  count = 1
  board.keys.each do |x|
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
end

def to_be_square(num)
  golden = 13/7.0
  divisor = 1
  mults = []
  result = num/divisor
  #binding.pry
  while true
    #binding.pry
    divisor += 1
    if (num/divisor.to_f) == (num/divisor)
      mults.push [divisor, result = num/divisor.to_f]
      if (divisor.to_f / result) > golden
        break
      end
    end

  end
  if mults.count > 1
    high = mults.reverse[0]
    low = mults.reverse[1]

    diff_high = (high[0]/high[1] - golden) / golden
    diff_low = (golden - low[0]/low[1]) / (low[0]/low[1])

    return (diff_high > diff_low ? high[0] : low[0])
  else
    return mults.flatten.last
  end
end

# def to_be_square(num)
#   guess = Math.sqrt(num).round
#   if guess % 2 != 0
#     guess += 1
#   end
#   guess
# end


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
  clear_screen
  print_title
  response = get_valid_input(
    "\t(1) Easy\n\t(2) Medium\n\t(3) Hard\n\nSelect difficulty: ",
    ("1".."3").to_a
  )
  return response.to_i
end

def get_custom_grid_size
  response = get_valid_input(
    "\Set the number of different cards (e.g. 6 for 12 cards): ",
    ("2".."20").to_a
  )
end

def set_grid_size
  clear_screen
  print_title
  response = get_valid_input(
    "\t(1) 12 cards (4 x 3)\n\t(2) 16 cards (4 x 4) \n\t(3) 20 cards (5 x 4)\n\t(4) Custom\n\n" +
    "Select option: ",
    ("1".."4").to_a
  )
  if response == "4"
    return get_custom_grid_size.to_i
  end
  return get_grid_size(response.to_i)
end

def get_grid_size(key)
  x = [
    6,
    8,
    10
  ]
  return x[key - 1]
end

def set_options(difficulty, data)
  clear_screen
  print_title
  response = get_valid_input(
    "\t(1) Set difficulty\n\t(2) Set grid size\n\nSelect option: ",
    ["1", "2"]
  )

  case response
  when "1"
    difficulty = set_difficulty
  when "2"
    data = load_data(set_grid_size)
  end
  return difficulty, data
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
    "\t(1) Play\n\t(2) Options\n\t(3) Quit\n\n" +
    "Select an option: ",
    ("1".."3").to_a
  )

  # default options

  difficulty = 1
  data = load_data(get_grid_size(1))

  case response
  when "2"
    difficulty, data = set_options(difficulty, data)
  when "3"
    exit_program
  end

  ### Start The Game

  until game_end

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
          if (lives > 1) && (! scored)
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
