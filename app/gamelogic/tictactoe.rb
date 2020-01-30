require_relative 'grid'
require_relative 'player'
require_relative 'computer'

class TicTacToe

    attr_reader :grid, :user, :computer, :grid_size

    def initialize(grid_size)
        @grid_size = grid_size
        @grid = Grid.new(grid_size)
        @user = Player.new(:player_1)
        @computer = Computer.new(:player_2, grid_size)
    end

    def display_grid
        grid.play_area.each { |row| puts row.join(" | ") }
    end

    def take_input
        puts "Please enter row number (1 indexed): "
        row = gets.chomp.to_i - 1

        puts "Please enter column number (1 indexed): "
        column = gets.chomp.to_i - 1

        {row: row, col: column}
    end

    def next_turn(usr_input)
        response = grid.take_move(user.id, usr_input)

        #{invalidmove: 0, victory: 1, draw: 2, continue: 3}


        case response
        when grid.game_state[:invalidmove] 
            puts "Invalid input, please try again."
            return false
        when grid.game_state[:victory]
            display_grid
            puts "Congratulations, you win!"
            return true
        when grid.game_state[:draw]
            display_grid
            puts "And that's a draw, come back again."
            return true
        else
            display_grid
            puts "Waiting for computer to make a move..."
            sleep(2)
            computer_turn            
        end
    end

    def computer_turn
        successful = false
        game_response = false
        until successful

            response = grid.take_move(computer.id, computer.make_move)

            #{invalidmove: 0, victory: 1, draw: 2, continue: 3}
            case response
            when grid.game_state[:invalidmove] 
                successful, game_response = false, false
            when grid.game_state[:victory]
                display_grid
                puts "Uh-oh, you lose!"
                successful, game_response = true, true
            when grid.game_state[:draw]
                display_grid
                puts "And that's a draw, come back again."
                successful, game_response = true, true
            else
                display_grid
                successful, game_response = true, false            
            end 
        end

        game_response
    end

end