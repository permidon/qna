class Api::V1::ProfilesController < Api::V1::BaseController
  authorize_resource :user

  def me
    respond_with current_resource_owner
  end

  def all_but_me
    respond_with User.where.not(id: current_resource_owner)
  end
end