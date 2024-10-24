# frozen_string_literal: true

require 'rails_helper'

describe Subscription do
  context 'associations' do
    it { is_expected.to belong_to :plan }
    it { is_expected.to belong_to :subscriber }
  end

  context 'instance methods' do
    describe '#notify!' do
      before do
        @subscription = build(:subscription, :for_updates, plan: create(:plan),
                                                           subscriber: build(:api_client))
      end

      it 'does not notify the subscriber if this is a new record' do
        expect(@subscription.notify!).to be(false)
      end

      it 'does not notify the subscriber if :callback_uri is not present' do
        @subscription.callback_uri = nil
        @subscription.save
        expect(@subscription.notify!).to be(false)
      end

      it 'does not notify the subscriber if :last_notified > plan.updated_at' do
        @subscription.last_notified = 1.day.from_now
        @subscription.save
        expect(@subscription.notify!).to be(false)
      end

      it 'notifies the subscriber' do
        @subscription.save
        NotifySubscriberJob.expects(:perform_later).with(@subscription).returns(true)
        expect(@subscription.notify!).to be(true)
      end
    end
  end
end
