Rails.application.routes.draw do

  scope module: :public, as: 'public' do
    resources :non_monetary_donations, path: :nepenezni_dary, path_names: { new: 'novy' } do
      member do
        get 'signed'
      end
    end
    resources :campaign_donations, path: :penezni_dary, path_names: { new: 'novy' } do
      member do
        get 'signed'
      end
    end
    resources :crowdfundings, path: :crowdfunding, only: [:index, :show]
  end

  scope ":year", year: /201[3-9]/, path_names: { new: 'pridat', edit: 'upravit' } do

    resources :bank_accounts
    resources :bank_payments, only: [:show] do
      member do
        post 'pair'
      end
    end

    resources :membership_fees

    resources :non_monetary_donations do
      member do
        get 'upload'
        get 'agreement', path: 'smlouva'
      end
    end
    resources :donations, path: 'dary' do
      member do
        get 'confirmation', path: 'potvrzeni'
        get 'agreement', path: 'smlouva'
        get 'upload'
      end
    end

    resources :payments, path: 'platby'

    resources :accountings

    resources :budgets
    resources :budget_categories
    resources :invoices, path: 'faktury' do
      collection do
        get 'unrecognized', to: 'invoices#unrecognized', path: 'neprirazene'
        get 'unreaded', to: 'invoices#unreaded', path: 'nevytezene'
        get 'unpaid', to: 'invoices#unpaid', path: 'nezaplacene'
        get 'unpaired', to: 'invoices#unpaired', path: 'nezauctovane'
        get 'unapproved', to: 'invoices#unapproved', path: 'neschvalene'
      end
      member do
        get 'approval', path: 'schvaleni'
        get 'pay'
        post 'export_to_fio'
      end
      resources :accountings, only: :index
    end

    resources :organizations, path: 'organizace', only: [:index, :show] do
      resources :donation_form_submissions, only: [:index, :show]
      resources :bank_payments, only: [:index]
      resources :gopay_payments, only: [:index]
      resources :budget_categories, path: 'rozpoctova_kapitola', only: [:index, :new]
      resource :budget, path: 'rozpocet', only: [:show, :edit, :update]
      resources :invoices, path: 'faktury', only: [:index, :new] do
        collection do
          get 'unrecognized', to: 'invoices#unrecognized', path: 'neprirazene'
          get 'unreaded', to: 'invoices#unreaded', path: 'nevytezene'
          get 'unpaid', to: 'invoices#unpaid', path: 'nezaplacene'
          get 'unpaired', to: 'invoices#unpaired', path: 'nezauctovane'
          get 'unapproved', to: 'invoices#unapproved', path: 'neschvalene'
        end
      end
      resources :tags, only: [:index]
      resources :accountings, only: [:index]
      resources :donations, path: 'dary', only: [:index] do
        collection do
          get 'above_limit', path: 'nad_limit'
          get 'crowdfunding'
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
    get '/prehled', to: 'static_pages#overview'

    get 'bank_payments', controller: :bank_payments, action: :index
    get 'supporter_fees', controller: :supporter_fees, action: :index

    # resources :books
    # root 'static_pages#index'

    get "/", to: 'static_pages#index', as: :dashboard
  end

  resources :invoices, path: 'faktury'
  resources :people, only: [:show]

  namespace :api do
    resources :bank_payments, only: :index
  end

  resources 'donation_form_submissions', only: [:create]

  get '/auth/:provider/callback', to: 'sessions#create'
  get '/sessions/destroy'

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  root 'static_pages#index'
  get '/zprava', to: 'static_pages#campaign_report', as: :campaign_report

end
