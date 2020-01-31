class GameController < ApplicationController
    
    def index
        @active_games = Game.where(status: 1)
    end
    
    def new
        @game = Game.new
    end

    def create
        # render plain: params[:game].inspect // redirect_to root_path // render plain: values.to_s --> Different things I've tried
        @game = Game.new(params[:game_data].permit(:board_size, :status, :winner))
        if @game.save
            redirect_to @game 
        else
            render 'new'
        end
        #render plain: @game.id.to_s
    end

    def show
        id = params[:id]
        @game = Game.find(id)
        @moves = generate_move_hash(@game)
    end

    def update
        
    end

    def destroy
        @game = Game.find(params[:id])
        @game.destroy
     
        redirect_to root_path
    end

    private

    def generate_move_hash (game_obj)
        moves = {}
        game_obj.board.to_a.each do |move|
            moves["#{move.row}_#{move.column}"] = move.symbol           
        end
        moves
    end
end