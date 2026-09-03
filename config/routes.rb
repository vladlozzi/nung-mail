Rails.application.routes.draw do
  resources :educational_programs
  root 'home#index'
  get 'new_import_emails' => 'emails#new_import'
  post 'new_import_emails' => 'emails#import'
  get 'new_import_students' => 'students#new_import'
  post 'new_import_students' => 'students#import'
  get 'new_import_applications' => 'applications#new_import'
  post 'new_import_applications' => 'applications#import'
  get 'create_new_emails_acadgr_table' => 'home#emails_acadgr_table'
  get 'create_new_emails_epysf_table' => 'home#emails_epysf_table'
  get 'new_import_edu_programs' => 'educational_programs#new_import'
  post 'new_import_edu_programs' => 'educational_programs#import'
end