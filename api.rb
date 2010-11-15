require 'grape'

module ConfAsk
  class API < Grape::API
    prefix 'api'
    version 'v1'
    
    helpers do
      def current_user
        @current_user ||= User.find_by_id(env['rack.session'][:user_id])
      end
      
      def authenticate!
        error!("Must be logged in.", 401) unless current_user
      end
    end
    
    get '/me' do
      authenticate!
      current_user
    end
    
    resources :questions do
      get do
        Question.sort([['$natural', -1]]).all
      end
      
      post do
        authenticate!
        if question = Question.create(:text => params[:text], :screen_name => current_user.screen_name)
          question
        else
          error! "Unable to create your question.", 403
        end
      end
      
      helpers do
        def question
          @question ||= Question.find_by_id(params[:id])
        end
      end
      
      get '/:id/votes' do
        authenticate!
        question.vote!
      end
    end
    
    # Only administrators can access the resources
    # in the `admin` namespace.
    namespace :admin do
      http_basic do |u,p| 
        u == 'admin' && p == (ENV['ADMIN_PASSWORD'] || 'rubyconf')
      end
      
      # Get a list of users who have signed into the
      # application.
      get '/users' do
        [{:hey => 'you'},{:there => 'bar'},{:foo => 'baz'}]
      end
      
      resources :votes do
        get do
          
        end
        
        # Delete a vote directly by providing its ID.
        #
        # @param [String ID] id The ID of the vote to be deleted.
        delete '/:id' do
          "Deleting #{params[:id]}"
        end
      end
    end
  end
end