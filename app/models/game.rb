class Game < ApplicationRecord
    has_many :board
    validates :board_size, presence: true, numericality: {greater_than_or_equal_to: 3, less_than_or_equal_to: 10}
end
