class FriendsController < ApplicationController
	def create
		inv = Invitation.find(params[:rsvp_id])
		Network.create(user:inv.user, friend:current_user)
		inv.destroy
		redirect_to root_path
	end
end
