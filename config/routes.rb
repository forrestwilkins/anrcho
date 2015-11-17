Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'proposals#index'
  
  # proposals
  get 'proposal/:token', to: 'proposals#show', as: 'show_proposal'
  get 'proposals/:token/show_image', to: 'proposals#show_image', as: 'proposal_image'
  get 'proposals/switch_section/:section', to: 'proposals#switch_section', as: 'switch_section'
  get 'proposals/add_image', as: 'add_proposal_image'
  post 'proposals/create', as: 'create_proposal'
  
  # votes
  get 'vote/:token', to: 'votes#show', as: 'show_vote'
  get 'for/:token', to: 'votes#new_up_vote', as: 'new_up_vote'
  get 'against/:token', to: 'votes#new_down_vote', as: 'new_down_vote'
  post 'votes/cast_up_vote', to: 'votes#cast_up_vote', as: 'cast_up_vote'
  post 'votes/cast_down_vote', to: 'votes#cast_down_vote', as: 'cast_down_vote'
  post 'reverse/:token', to: 'votes#reverse', as: 'reverse_vote'
  get 'verify/:token', to: 'votes#verify', as: 'verify_vote'
  post 'votes/confirm_humanity', as: 'confirm_humanity' 
  
  # comments
  get 'comments/:token', to: 'comments#show', as: 'show_comment'
  post 'comments', to: 'comments#create', as: 'comments'
  
  # groups
  get 'groups/toggle_manifesto/:group_token', to: 'groups#toggle_manifesto', as: 'toggle_group_manifesto'
  
  # manifestos
  get 'manifestos/toggle_manifesto', as: 'toggle_manifesto'
  
  # search
  get 'search', to: 'search#index', as: 'search'
  get 'search/new', to: 'search#new', as: 'new_search'
  get 'search/toggle_menu', as: 'toggle_menu'
  
  # tokens
  get 'token', to: 'token#index', as: 'token'
  get 'renew', to: 'token#update'
  
  # pages
  get 'fib', to: 'pages#fib', as: 'fib'
  get 'high_energy', to: 'pages#high_data', as: 'high_data'
  get 'low_energy', to: 'pages#low_data', as: 'low_data'
  get 'pages/more', as: 'more'
  get 'pages/finish_loading'
  
  # messages
  post 'messages/create', as: 'messages'
  get 'messages/instant_messages', to: 'messages#instant_messages'
  get 'groups/:group_token/chat', to: 'messages#index', as: 'chat'
  get 'secret/:receiver_token', to: 'messages#index', as: 'secret_chat'
  post 'chat', to: 'messages#new_chat', as: 'new_chat'
  get 'messages/add_image', as: 'add_message_image'
  get 'inbox', to: 'messages#inbox', as: 'inbox'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products
  resources :tips
  resources :notes
  resources :groups
  resources :manifestos
  resources :proposals do
    resources :comments
  end

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
