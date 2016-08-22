class InvitationsController < ApplicationController
	def create
		invitee = User.find(params[:conn_id])
		Invitation.create(user:current_user, invitee:invitee)
		redirect_to users_path
	end

	def destroy
		Invitation.find(params[:id]).destroy
		redirect_to root_path
	end
end
