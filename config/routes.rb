Rails.application.routes.draw do

  scope "(:year)", year: /201[3-9]/, path_names: { new: 'pridat', edit: 'upravit' } do

    resources :bank_accounts
    resources :bank_payments, only: [:show]

    resources 'donation_form_submissions', only: [:create]

    resources :membership_fees

    resources :people, only: [:show]

    resources :donations, path: 'dary' do
      member do
        get 'confirmation', path: 'potvrzeni'
        get 'agreement', path: 'smlouva'
      end
    end

    resources :payments

    resources :accountings

    resources :budget_categories
    resources :invoices, path: 'faktury' do
      member do
        post 'export_to_fio'
      end
      resources :accountings, only: :index
    end

    resources :organizations, path: 'organizace', only: [:index, :show] do
      resources :donation_form_submissions, only: [:index, :show]
      resources :bank_payments, only: [:index]
      resources :gopay_payments, only: [:index]
      resources :budget_categories, path: 'rozpocet', only: [:index]
      resources :invoices, path: 'faktury', only: [:index, :new] do
        collection do
          get 'unrecognized', to: 'invoices#index', only: :unrecognized, path: 'neprirazene'
          get 'unreaded', to: 'invoices#index', only: :unreaded, path: 'nevytezene'
          get 'unpaid', to: 'invoices#index', only: :unpaid, path: 'nezaplacene'
          get 'unpaired', to: 'invoices#index', only: :unapproved, path: 'nezauctovane'
          get 'unapproved', to: 'invoices#index', only: :unapproved, path: 'neschvalene'
        end
      end
      resources :tags, only: [:index]
      resources :accountings, only: [:index]
      resources :donations, path: 'dary', only: [:index] do
        collection do
          get 'above_limit', path: 'nad_limit'
        end
      end
      resources :membership_fees, path: 'clenske_prispevky', only: [:index] do
        collection do
          get 'distribution'
        end
      end
    end

    # scope "/years/:year", as: 'year' do
    #   resources :organizations, only: [:index, :show] do
    #     resources :bank_payments, only: [:index]
    #     resources :gopay_payments, only: [:index]
    #     resources :budget_categories, only: [:index]
    #     resources :invoices, only: [:index, :new]
    #     resources :tags, only: [:index]
    #     resources :accountings, only: [:index]
    #     resources :donations, only: [:index] do
    #       collection do
    #         get 'above_limit'
    #       end
    #     end
    #     resources :membership_fees, only: [:index] do
    #       collection do
    #         get 'distribution'
    #       end
    #     end
    #   end
    # end

    get 'static_pages/index'

    get 'bank_payments', controller: :bank_payments, action: :index
    get 'supporter_fees', controller: :supporter_fees, action: :index

    # resources :books
    # root 'static_pages#index'

    get "/", to: 'static_pages#index', as: :dashboard
  end


  get '/auth/:provider/callback', to: 'sessions#create'
  get '/sessions/destroy'

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  root 'static_pages#index'

end
