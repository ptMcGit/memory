# memory game

def clear_screen
  system("clear")
end

def did_win?(board, correct_guesses)
  board.map { |key, value| key } == correct_guesses.sort
end

def end_game(board)
  print "The game has ended.\n\n"
  print "Would you like to play again (y/n)? "
  until ["y","n"].include?  r = gets.chomp
    print "(y/n)? "
  end
  return r == "y"
end

def set_lives(board, difficulty)
  lives = 5
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
  ["a", "b", "c"]
  #("a".."z").to_a
end

def guesses_good(board, turn_guesses)
  x = Hash[board.select { |x, y| turn_guesses.include? x }].map {|x,y| y}
  x[0] == x[1]
end

def print_board(board, correct_guesses, turn_guesses)
  card_width = board.to_a.last[0].to_s.length
  count = 1

  board.map { |key, value| key }.each do |x|
    if (correct_guesses + turn_guesses).include? x
      print " [", (board[x].center card_width), "] "
    else
      print " [", (x.to_s.center card_width), "] "
    end
    if count % close_perfect_square_root(board.count)  == 0
      print "\n"
    end
    count += 1
  end
  print "\n"
end

def close_perfect_square_root(num)
  guess = 1
  until ((guess + 1) ** 2) > num
    guess += 1
  end
  return guess
end

def get_valid_input(valid_input)
  print "What is your guess? (q to quit)"
  until valid_input.include? response = gets.chomp
    print "Please enter a valid selection: "
  end
  return response
end

def array_of_nums_as_strings(num_array)
  num_array.map { |x| x.to_s }
end

prog_exit = false

# Main program

clear_screen

until prog_exit

  # start menu stuff

  game_end = false

  ### Start The Game

  until game_end

    data = load_data
    board = create_board(data)
    board_size = data.length * 2

    lives = set_lives(board, nil)
    correct_guesses = []

    game_over = false

    until game_over do

      turn_guesses = []
      tries = set_tries(nil)
      no_more_tries = false

      until no_more_tries
        clear_screen
        print "You have #{lives} " + "li" + (lives > 1 ? "ves" : "fe") + " remaining.\n\n"
        print_board(board, correct_guesses, turn_guesses)
        puts "Tries: #{tries}\n\n"

        scored = false

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

    if win
      print "Great job! You win!\n\n"
    else
      print "Maybe next time...\n\n"
    end

    print_board(board, (1..board_size).to_a, [])

    if end_game(nil)
      next
    else
      prog_exit = true
      puts "Goodbye!"
      break
    end
    next
  end
end
