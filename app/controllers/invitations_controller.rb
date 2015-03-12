class InvitationsController < Devise::InvitationsController
  before_action :can_send_invites?, only: [:new, :create]

  def can_send_invites?
    redirect_to root_path unless can? :invite, User
  end

end