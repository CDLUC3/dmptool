# frozen_string_literal: true

# Security rules for the public pages
# Note the method names here correspond with controller actions
class PublicPagePolicy < ApplicationPolicy
  # rubocop:disable Lint/MissingSuper
  def initialize(object, object2 = nil)
    @object = object
    @object2 = object2
  end
  # rubocop:enable Lint/MissingSuper

  def plan_index?
    true
  end

  def template_index?
    true
  end

  def template_export?
    @object.present? && @record.published?
  end

  def plan_export?
    @object2.publicly_visible?
  end

  def plan_organisationally_exportable?
    plan = @object
    user = @object2
    if plan.is_a?(Plan) && user.is_a?(User)
      return plan.publicly_visible? || (plan.organisationally_visible? && plan.owner.present? &&
        plan.owner.org_id == user.org_id)
    end

    false
  end
end
