# frozen_string_literal: true

# Security rules for users
# Note the method names here correspond with controller actions
class UserPolicy < ApplicationPolicy
  def index?
    admin_index?
  end

  def admin_index?
    @user.can_grant_permissions?
  end

  def admin_grant_permissions?
    @user.can_super_admin? || (@user.can_grant_permissions? && same_org?)
  end

  def admin_update_permissions?
    @user.can_super_admin? || (@user.can_grant_permissions? && same_org?)
  end

  # Allows the user to swap their org affiliation on the fly
  def org_swap?
    @user.can_super_admin?
  end

  def activate?
    @user.can_super_admin?
  end

  def edit?
    @user.can_super_admin? || (@user.can_org_admin? && same_org?)
  end

  def update?
    @user.can_super_admin? || (@user.can_org_admin? && same_org?)
  end

  def user_plans?
    @user.can_super_admin? || (@user.can_org_admin? && same_org?)
  end

  def update_email_preferences?
    true
  end

  def acknowledge_notification?
    true
  end

  def refresh_token?
    @user.can_super_admin? ||
      (@user.can_org_admin? && @user.can_use_api?)
  end

  def merge?
    @user.can_super_admin?
  end

  def archive?
    @user.can_super_admin?
  end

  def search?
    @user.can_super_admin?
  end

  def org_admin_other_user?
    @user.can_super_admin? || (@user.can_org_admin? && same_org?)
  end

  # DMPTool custom endpoints

  def revoke_oauth_access_token?
    @user.present?
  end

  def third_party_apps?
    @user.present?
  end

  def developer_tools?
    @user.present?
  end

  # Aliases due to lack of support for namespacing
  def users_third_party_apps_path?
    third_party_apps?
  end

  def users_developer_tools_path?
    developer_tools?
  end

  # Basic scope for the current user
  class Scope < Scope
    def resolve
      @scope.where(org_id: @user.org_id)
    end
  end
  
  private

  # The managed user (record) must belong to the same Org as the current user.
  #
  # Both `user`/`@user` and `record` are set by ApplicationPolicy#initialize, which
  # Pundit calls as UserPolicy.new(current_user, target). So:
  #   @user  => the caller (current_user) performing the action
  #   record => the object being acted on (the user passed to `authorize`)
  #
  # The previous checks compared `user.org_id == @user.org_id`, but `user` is just
  # the attr_reader for `@user`, so that compared the caller to itself and was
  # always true. Comparing `record.org_id` instead enforces the real org boundary.
  #
  # `record.is_a?(User)` guards against callers that authorize the User class
  # itself (e.g. `authorize User`), which has no org_id.
  def same_org?
    record.is_a?(User) && record.org_id.present? && record.org_id == @user.org_id
  end
end
