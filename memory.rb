# memory game

# goals get a minimal game working

require "pry"

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

def combine_hashes(hash1, hash2)
  hash2 = hash2.clone
  hash1.each do |key,value|
    if value
      hash2[key] = value
    end
  end
  return hash2
end


def guesses_good(hash1)
  guesses = hash1.to_a.select do |x|
    x[1]
  end
  #binding.pry
  guesses.map { |x,y| y }.uniq.count == 1
end
  

def create_guess_board(board)
  Hash[board.to_a.map { |x| [x[0],nil] }]
end


def print_board(board)
  size = board.count
  size_of_block = board.to_a.last[0].to_s.length
  count = 1
  board.to_a.each do |x|
    #print x[1] || x[0]
    printf("%.2s ", x[1] || x[0].to_s)
    #binding.pry
    if count % print_new_line(size) == 0
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



# def ceilinged_square_root(num)
#   guess = num / 2
#   until (guess ** 2) < num && num > ((guess + 1) ** 2)
#     guess += 1
#   end
#     return guess + 1
# end

#binding.pry


#def synthesize_board(board1, board2)

  #result = (board1.to_a.select do |x|
   #           x[1]
    #        end) + (board2.to_a.select do |x|
     #                 x[1]
      #              end)

#  board = create_board
#  board1.select do |x|


#  binding.pry
#end


def  get_response
  print "What is your guess? (q to quit)"
  gets.chomp.to_i
end

prog_exit = false
until prog_exit


  lives = 10
  game_end = false

  # start the game
  until game_end
    #  board = create_board(load_objects)

    board = create_board(["a","b","c","d","e"])
    guesses = create_guess_board(board)
    correct_guesses = guesses.clone
    
    dead = false

    # board created now start turns

    until dead

      flip_over = false
      #print_board(correct_guesses)
      turn_guesses = []  
      tries = 2
      no_more_tries = false

      until no_more_tries
        puts "Lives #{lives} Remaining:"
        print_board(combine_hashes(guesses, correct_guesses))
        turn_guesses.push (guess = get_response)
        tries -= 1
        guesses[guess] = board[guess]
        #binding.pry

        #binding.pry
        print_board(combine_hashes(guesses, correct_guesses))
        #binding.pry
        #lives -= 1

        #binding.pry
        #correct_guesses = guesses.to_a.select{ |x| x[1] != nil}

        if tries == 0
          #binding.pry
          puts "End of turn"
          sleep 1
          #binding.pry
          if guesses_good(guesses)
            correct_guesses = guesses.clone
          else
            guesses = correct_guesses.clone
            lives -= 1
          end
          no_more_tries = true
          
        end

      end

      #if lives == 0
      #  game_end = true
      #end


      #if turn_guesses.uniq == 1
      #  correct_guesses = guesses.clone
      #end
    end
  end
end
