# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserPolicy, type: :policy do
  subject { described_class.new(user, record) }

  let(:org_scoped_actions) do
    %i[admin_grant_permissions admin_update_permissions edit update
       user_plans org_admin_other_user]
  end

  let(:super_admin_actions) { %i[super_admin_edit super_admin_update] }

  let(:org) { create(:org, managed: true) }
  let(:other_org) { create(:org, managed: true) }
  let(:same_org_user) { create(:user, org: org) }
  let(:other_org_user) { create(:user, org: other_org) }

  context 'super_admin' do
    let(:user) { create(:user, :super_admin, org: org) }

    context 'managing a user in another org' do
      let(:record) { other_org_user }

      it 'is permitted' do
        expect(subject).to permit_actions(org_scoped_actions)
      end

      it 'is permitted the super-admin-only actions' do
        expect(subject).to permit_actions(super_admin_actions)
      end
    end
  end

  context 'org_admin' do
    let(:user) { create(:user, :org_admin, org: org) }

    context 'managing a user in their own org' do
      let(:record) { same_org_user }

      it 'is permitted' do
        expect(subject).to permit_actions(org_scoped_actions)
      end

      it 'is forbidden the super-admin-only actions' do
        expect(subject).to forbid_actions(super_admin_actions)
      end
    end

    context 'managing a user in another org' do
      let(:record) { other_org_user }

      it 'is forbidden' do
        expect(subject).to forbid_actions(org_scoped_actions)
      end

      it 'is forbidden the super-admin-only actions' do
        expect(subject).to forbid_actions(super_admin_actions)
      end
    end
  end

  context 'regular user' do
    let(:user) { create(:user, org: org) }
    let(:record) { same_org_user }

    it 'is forbidden' do
      expect(subject).to forbid_actions(org_scoped_actions)
    end

    it 'is forbidden the super-admin-only actions' do
      expect(subject).to forbid_actions(super_admin_actions)
    end
  end
end
