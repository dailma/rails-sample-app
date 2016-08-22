Rails.application.routes.draw do
	root	"users#index"

	post	"sessions"				=> "sessions#create"
	delete	"sessions"				=> "sessions#destroy"

	get		"professional_profile"	=> "users#index"

	get		"users"					=> "users#connect"
	post	"users"					=> "users#create"
	get 	"users/new"				=> "users#new"
	get 	"users/:id"				=> "users#show"

	post	"invitations"			=> "invitations#create"
	delete	"invitations/:id"		=> "invitations#destroy"

	post	"friends"				=> "friends#create"

	get		"login"					=> "users#new"
	get		"logout"				=> "sessions#destroy"
	get		"register"				=> "users#new"
end
