require_relative "../gamelogic/grid"
require_relative "../gamelogic/computer"
class MoveController < ApplicationController
    protect_from_forgery with: :null_session

    def make
        # Read data from input params
        request_data = params[:move]
        game_id = request_data[:gameid].to_i
        row = request_data[:row].to_i
        col = request_data[:column].to_i
        
        @game = Game.find(game_id)
        valid_move = row < @game.board_size && col < @game.board_size
        @game_grid = Grid.new(@game.board_size, @game.board.to_a)
        @computer = Computer.new(:Computer, @game.board_size)

        if @game.board.to_a.any? { |move| move.row == row && move.column == col } || !valid_move
            redner json: {msg: "Invalid move."}, status: :bad_request
        else
            
            continue, message, computer_move = false, "", {}

            @move = @game.board.create(row: row, column: col, symbol: "X", move_by: :Player, move_time: Date.new)
            response = @game_grid.take_move(row: row, col: col, symbol: "X")
            continue, message = process_response(response, :Player)
            
            if continue
                computer_response, computer_move = computer_turn
                continue, message = process_response(computer_response, :Computer)    
            end
            
            api_response = {message: message, continue:continue, computer_move: computer_move}

            render json: api_response, status: :ok
        end
    end

    private

    def computer_turn
        successful = false
        response = nil
        move = {}
        until successful
            move = @computer.make_move
            response = @game_grid.take_move(move)
            successful = response != @game_grid.game_state[:invalidmove] 
        end

        @game.board.create(row: move[:row], column: move[:col], symbol: move[:symbol], move_by: :Computer, move_time: Date.new)

        [response, move]
    end

    def process_response(response, player_name)
        case response
        when @game_grid.game_state[:victory]
            @game.update(status: 2, winner: player_name)
            return [false, "#{player_name} WINS!"]
        when @game_grid.game_state[:draw]
            @game.update(status: 3, winner: "DRAW")
            return [false, "That's a draw!"]
        else
            return [true, "Continue"]
        end
    end
end
