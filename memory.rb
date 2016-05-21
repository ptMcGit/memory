# memory game

def clear_screen
  system("clear")
end

def did_win?(board, correct_guesses)
  board.map { |key, value| key } == correct_guesses.sort
end

def end_game(board)
  puts "The game has ended."
  #reveal_board
  print "Would you like to play again (y/n)? "
  until ["y","n"].include?  r = gets.chomp
    print "(y/n)? "
  end
  if r == "y"
    return true
  else
    return false
  end
end

def set_lives(board, difficulty)
  lives = 5
  #return (0..lives).to_a
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
  return board
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
  size = board.count
  size_of_block = board.to_a.last[0].to_s.length
  count = 1

  board.map { |key, value| key }.each do |x|
    if (correct_guesses + turn_guesses).include? x
      print " [", (board[x].center size_of_block), "] "
    else
      print " [", (x.to_s.center size_of_block), "] "
    end
    if count % close_perfect_square_root(size)  == 0
      print "\n"
    end
    count += 1
  end
  print "\n"
end


def print_new_line(size)
  # return the closest perfect square of size * 2
  return 3
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

    dead = false

    until dead do

      turn_guesses = []
      tries = set_tries(nil)
      no_more_tries = false

      until no_more_tries
        clear_screen
        print "You have #{lives} " + "li" + (lives > 1 ? "ves" : "fe") + " remaining.\n"
        print_board(board, correct_guesses, turn_guesses)
        puts "#{tries}"

        if tries == 0
          print "End of turn. Press enter to continue ... "
          gets
          break
        else
          response = get_valid_input(
            ["q"] +
            array_of_nums_as_strings((1..board_size).to_a - correct_guesses - turn_guesses)
          )
        end

        if response == "q";
          dead = true
          break
        else
          turn_guesses.push response.to_i
        end
        tries -= 1
      end

      if guesses_good(board, turn_guesses)
        correct_guesses.concat turn_guesses
      else
        lives -= 1
      end

      #print_board(board, correct_guesses, turn_guesses)
      if lives == 0
        dead = true
      #else
      #  puts "End of turn. Press enter to continue."
      #  gets
      end

    end

    clear_screen
    
    if did_win?(board, correct_guesses)
      puts "Great job! You win!"
    else
      puts "Maybe next time..."
      print_board(board, (1..board_size).to_a, [])
    end

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
