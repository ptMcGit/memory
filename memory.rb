# memory game

# goals get a minimal game working

require "pry"

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
  5
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

def load_objects
  ["a", "b", "c", "d"]
end

def guesses_good(board, turn_guesses)
  x = Hash[board.select { |x, y| turn_guesses.include? x }].map {|x,y| y}
  x[0] == x[1]
end

# def resolve_guesses(board, turn_guesses)
#   b = {}
#   h = Hash[board.select { |x,y| turn_guesses.include? x }].map { |x,y| b[y]=[x] }
#   #[a]
#   resolved_guesses = board.select { |x,y| turn_guesses.include? x }.map { |x,y| y }
#   #resolved_guesses.each
#   totals = Hash.new(0)
#   totals.each do |x|
#     totals[x] += 1
#   end
#   totals.select do |x|
#     x > 1
#   end
#   binding.pry
# end

#  items.uniq.count == 1
#end  
  
#   board.select do |x,y|
#     [2,8].include? x
#   end
#   turn_guesses.uniq.count == 1
# end
 
  
  # guesses = hash1.to_a.select do |x|
  #   x[1]
  # end
  #binding.pry
#  guesses.map { |x,y| y }.uniq.count == 1
#end

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
      #binding.pry
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





#def closest_sqrt_below(num)
  
#  until (guess ** 2)


# def ceilinged_square_root(num)
#   guess = num / 2
#   until (guess ** 2) < num && num > ((guess + 1) ** 2)
#     guess += 1
#   end
#     return guess + 1
# end

def close_perfect_square_root(num)
  guess = 1
  until ((guess + 1) ** 2) > num 
    guess += 1
  end
  return guess
end

def  get_valid_input(valid_input)
  print "What is your guess? (q to quit)"
  until valid_input.include? response = gets.chomp
    print "Please enter a valid selection: "
    #binding.pry
  end
  return response
end

def array_of_nums_as_strings(num_array)
  num_array.map { |x| x.to_s }
end

prog_exit = false

until prog_exit


  game_end = false

  # start the game
  until game_end
    #  board = create_board(load_objects)
    data = ("a".."d").to_a
    board_size = data.length * 2
    board = create_board(data)
    lives = set_lives(board, false)

    dead = false

    # board created now start turns

    correct_guesses = []
    until dead

      #print_board(correct_guesses)
      turn_guesses = []
      tries = 2
      no_more_tries = false

      until no_more_tries

        if lives == 0
          dead = true
          break
        end
        
        puts "Lives #{lives} Remaining:"
        print_board(board, correct_guesses, turn_guesses)
        response = get_valid_input(
          ["q"] +
          array_of_nums_as_strings((1..board_size).to_a - correct_guesses - turn_guesses)
        )

        if response == "q";
          dead = true
          break
        else
          turn_guesses.push response.to_i
          #binding.pry
          print_board(board, correct_guesses, turn_guesses)
          tries -= 1

        end
        if tries == 0
          no_more_tries = true
          
          if guesses_good(board, turn_guesses)
            correct_guesses.concat turn_guesses
          else
            lives -= 1
          end

          puts "End of turn"
          sleep 1
        end
      end
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
