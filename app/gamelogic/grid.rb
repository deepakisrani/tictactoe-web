require_relative 'umpire'

class Grid
    attr_reader :play_area, :game_state, :turn

    def initialize(grid_size, move_list)
        @game_state = {invalidmove: 0, victory: 1, draw: 2, continue: 3}
        @match_state = {active: 1, player_win: 2, computer_win: 3, draw: 4}

        @grid_size = grid_size
        @move_list = move_list
        @play_area = generate_grid(@grid_size)
        @area_size = @grid_size ** 2
        fill_grid
        @turn = move_list.length
    end

    def take_move(move)
        row, col, symbol = move[:row], move[:col], move[:symbol]
        if row < grid_size && col < grid_size && play_area[row][col].nil?
            play_area[row][col] = symbol
            @turn += 1

            if Umpire.game_won?(play_area, symbol)
                game_state[:victory]                
            elsif @turn == area_size
                game_state[:draw]
            else
                game_state[:continue]               
            end
        else
            game_state[:invalidmove]
        end
    end

    private
    attr_reader :area_size, :grid_size
    attr_writer :turn

    def generate_grid(grid_size)
        play_area = []
        grid_size.times { play_area << Array.new(grid_size)}
        play_area
    end

    def fill_grid
        @move_list.each do |move|
            @play_area[move.row][move.column] = move.symbol
        end
    end
end