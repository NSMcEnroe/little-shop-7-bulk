Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root "welcome#index"

  get "/merchants/:merchant_id/dashboard", to: "merchants#show"
  get "/merchants/:merchant_id/items", to: "merchant_items#index"
  get "/merchants/:merchant_id/items/new", to: "merchant_items#new"
  post "/merchants/:merchant_id/items/create", to: "merchant_items#create"
  get "/merchants/:merchant_id/items/:item_id", to: "merchant_items#show"
  get "/merchants/:merchant_id/invoices", to: "merchant_invoices#index"
  get "/merchants/:merchant_id/invoices/:invoice_id", to: "merchant_invoices#show"
  patch "/merchants/:merchant_id/invoices/:invoice_id", to: "merchant_invoices#update", as: "merchant_invoice_update"
  patch "/merchants/:merchant_id/items/:item_id", to: "merchant_items#update"
  patch "/admin/invoices/:invoice_id", to: "admin/invoices#update", as: "admin_invoice_update"
  get "/items/:id/edit", to: "items#edit"
  patch "/items/:id", to: "items#update"

  resources :merchants do
    resources :bulk_discounts, controller: "merchant_bulk_discounts"
  end

  namespace :admin, path: "/admin" do
    get "", to: "dashboard#index", as: "dashboard"

    resources :merchants do
      member do
        put :disable_enable, to: "merchants#disable_enable", as: :disable_enable
      end
    end

    resources :invoices, only: [:show]
  end

  get "/admin/invoices", to: "admin/invoices#index"
  get "/admin/invoices/:id", to: "admin/invoices#show"
end
