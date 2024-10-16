Rails.application.routes.draw do
  root 'home#index'
  get 'new_import_emails' => 'emails#new_import'
  post 'new_import_emails' => 'emails#import'
  get 'new_import_students' => 'students#new_import'
  post 'new_import_students' => 'students#import'
  get 'new_import_applications' => 'applications#new_import'
  post 'new_import_applications' => 'applications#import'
  get 'create_new_emails_table' => 'home#emails_table'
end