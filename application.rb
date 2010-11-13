require 'sinatra'

module ConfAsk
  class Application < Sinatra::Base
    helpers do
      def current_user
        @current_user ||= User.find_by_id(session[:user_id])
      end
    
      def current_user=(user)
        session[:user_id] = user.id
        @current_user = user
      end
    end
          
    get '/' do
      erb :home
    end
    
    get '/auth/twitter/callback' do
      self.current_user = User.authenticate(request.env['omniauth.auth'])
      redirect '/'
    end
    
    get '/sign_out' do
      session.delete(:user_id)
      @current_user = nil
      redirect '/'
    end
  end
end