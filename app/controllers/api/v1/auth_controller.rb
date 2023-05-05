class Api::V1::AuthController < ApplicationController
    def signup
      user = User.new(user_params)
      if user.save
        render json: { token: encode_token(user.id) }
      else
        render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    def login
      user = User.find_by(email: params[:email])
      if user && user.authenticate(params[:password])
        render json: { token: encode_token(user.id) }
      else
        render json: { error: 'Invalid email or password' }, status: :unauthorized
      end
    end
  
    private
  
    def user_params
      params.require(:user).permit(:email, :password)
    end
  
    def encode_token(user_id)
      JWT.encode({ user_id: user_id }, 'mysecret')
    end
  end
  