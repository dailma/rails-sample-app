class User < ActiveRecord::Base
	has_many :invitations
	has_many :networks
	has_many :friends, :through => :networks, :source => :users

	validates :name, :presence => { :message => "Name can't be blank" }

	email_regex = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]+)\z/i
	validates :email, :format => { :with => email_regex, :message => "Email isn't valid" }
	validates :email, :uniqueness => { :case_sensitive => false, :message => "Email address is already registered" }

	validates :password, :length => { :minimum => 8 }, :on => :create
	has_secure_password

	validates :description, :presence => { :message => "Description can't be blank" }

	before_save do
		self.email.downcase!
	end
end
