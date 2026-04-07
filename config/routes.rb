Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :site do
      namespace :v1 do
        resources :notifications, only: %i[index] do
          collection do
            put '/read_all', to: 'notifications#read_all'
            put '/:uuid/read', to: 'notifications#read'
            put '/:uuid/close', to: 'notifications#close'
          end
        end
      end
    end
  end
end
