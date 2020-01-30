require_relative 'player'

class Computer < Player
    def initialize(id, grid_size)
        super(id)
        @selection_range = 0..grid_size
    end

    def make_move
        {row: rand(selection_range), col: rand(selection_range)}
    end

    private
    attr_reader :selection_range
end