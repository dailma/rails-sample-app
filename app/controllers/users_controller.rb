class UsersController < ApplicationController
	def index
		if !current_user
			flash[:log_errors] = ["Please sign in"]
			redirect_to users_new_path
		else
			@user = current_user
			@connections = []
			friends = Network.where(user:@user)
			friends.each do |friend|
				@connections << [friend.friend.id, friend.friend.name]
			end
			friends = Network.where(friend:@user)
			friends.each do |friend|
				@connections << [friend.user.id, friend.user.name]
			end
			invitations = Invitation.where(invitee:@user)
			@inviters = []
			invitations.each do |invitation|
				@inviters << [invitation.id, invitation.user.id, invitation.user.name]
			end
		end
	end

	def new
		if current_user
			flash[:errors] = ["You're already signed in as #{current_user.name}"]
			redirect_to root_path
		end
	end

	def connect
		if !current_user
			flash[:log_errors] = ["Please sign in"]
			redirect_to users_new_path
		else
			user = current_user
			exclude_ids = Invitation.where(user:user).distinct.pluck(:invitee_id) + Invitation.where(invitee:user).distinct.pluck(:user_id) + Network.where(user:user).distinct.pluck(:friend_id) + Network.where(friend:user).distinct.pluck(:user_id)
			exclude_ids << user.id
			users = User.where.not(id:exclude_ids.uniq)
			@connectables = []
			users.each do |user|
				@connectables << [user.id, user.name]
			end
			@pending = []
			Invitation.where(user:user).each do |inv|
				@pending << [inv.invitee.id, inv.invitee.name]
			end
		end
	end

	def show
		if !current_user
			flash[:log_errors] = ["Please sign in"]
			redirect_to users_new_path
		else
			@user = User.find(params[:id])
		end
	end

	def create
		user = User.new(user_params)
		if user.invalid?
			flash[:reg_errors] = []
			user.errors.each do |attr, msg|
				case attr  # modifies errors from SecurePassword
				when :password
					flash[:reg_errors] << "Password #{msg}" if msg != "can't be blank"
				when :password_confirmation
					flash[:reg_errors] << "Password and password confirmation don't match"
				else
					flash[:reg_errors] << msg
				end
			end
			redirect_to users_new_path
		else
			user.save
			session[:user_id] = user.id
			session[:name] = user.name
			flash[:success] = "Your account is ready for use"
			redirect_to root_path
		end
	end

	private
	def user_params
		params.require(:user).permit(:name, :email, :password, :password_confirmation, :description)
	end
end
