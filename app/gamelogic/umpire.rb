module Umpire
    def self.game_won?(play_area, last_sym)
        rows_won?(play_area, last_sym) || cols_won?(play_area, last_sym) || diagonals_won?(play_area, last_sym)
    end

    private

    def self.win_condition? (elements, last_sym)
        elements.all? {|ele| ele == last_sym}
    end

    def self.rows_won?(play_area, last_sym)
        play_area.any? { |row| win_condition?(row, last_sym) }
    end

    def self.cols_won?(play_area, last_sym)
        grid_len = play_area.length
        win_condition = false

        grid_len.times do |i|
            win_condition = win_condition?(play_area.map {|row| row[i]}, last_sym)
            break if win_condition
        end

        win_condition
    end

    def self.diagonals_won?(play_area, last_sym)
        grid_len = play_area.length
        diagonal_one, diagonal_two = [], []
        
        grid_len.times do |i|
            diagonal_one << play_area[i][i]
            diagonal_two << play_area[i][grid_len - 1 - i]
        end

        win_condition?(diagonal_one, last_sym) || win_condition?(diagonal_two, last_sym) 
    end
end