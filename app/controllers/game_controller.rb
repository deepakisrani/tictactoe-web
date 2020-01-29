class GameController < ApplicationController
    
    def index
        @active_games = Game.where(status: 1)
    end
    
    def new
        
    end

    def create
        # render plain: params[:game].inspect // redirect_to root_path // render plain: values.to_s --> Different things I've tried
        values = params[:game].dup
        values[:board_size] = 3 if values[:board_size].to_i < 3
        @game = Game.new(values.permit(:board_size, :status, :winner))
        @game.save

        redirect_to @game
        #render plain: @game.id.to_s
    end

    def show
        id = params[:id]
        @game = Game.find(id)
    end

    def update
        
    end
end
