class MoveController < ApplicationController
    protect_from_forgery with: :null_session

    def make
        render json: {msg: params[:move]}, status: :ok
    end
end
