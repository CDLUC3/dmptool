module RolesHelper

  def build_plan(administrator = false, editor = false, commenter = false)
    org = create(:org)
    plan = create(:plan, answers: 2, guidance_groups: 2, org: org)
    creator = create(:user, org: org)
    create(:role, :creator, :active, plan: plan, user: creator)

    if administrator
      create(:role, :administrator, :active, plan: plan, user: create(:user, org: org))
    end
    if editor
      create(:role, :editor, :active, plan: plan, user: create(:user, org: org))
    end
    if commenter
      create(:role, :commenter, :active, plan: plan, user: create(:user, org: org))
    end
    plan
  end

end
