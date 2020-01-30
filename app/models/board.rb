class Board < ApplicationRecord
    belongs_to :game, dependent: :destroy
end
