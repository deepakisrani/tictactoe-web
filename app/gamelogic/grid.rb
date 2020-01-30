require_relative 'umpire'

class Grid
    attr_reader :play_area, :game_state, :turn

    # Creates and initializes a n*n array (play area) 
    def initialize(grid_size)
        @game_state = {invalidmove: 0, victory: 1, draw: 2, continue: 3}
        @grid_size = grid_size < 3 ? 3 : grid_size
        @play_area = generate_grid(@grid_size)
        @area_size = @grid_size ** 2
        @turn = 0
    end

    def get_play_symbols
        PLAY_SYMBOLS
    end

    def take_move(player, position)
        row, col = position[:row], position[:col]
        if row < grid_size && col < grid_size && play_area[row][col].nil?
            play_area[row][col] = PLAY_SYMBOLS[player]
            @turn += 1

            if Umpire.game_won?(play_area, PLAY_SYMBOLS[player])
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
    PLAY_SYMBOLS = { player_1: :x, player_2: :o }
    attr_reader :area_size, :grid_size
    attr_writer :turn

    def generate_grid(grid_size)
        play_area = []
        grid_size.times { play_area << Array.new(grid_size)}
        play_area
    end
end