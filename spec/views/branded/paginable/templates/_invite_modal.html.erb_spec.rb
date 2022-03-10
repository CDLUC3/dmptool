# frozen_string_literal: true

require 'rails_helper'

describe 'paginable/templates/_invite_modal.html.erb' do
  it 'renders the modal dialog container' do
    controller.prepend_view_path 'app/views/branded'
    render partial: '/paginable/templates/invite_modal'
    expect(rendered.include?('id="modal-invite"')).to eql(true)
    expect(rendered.include?('class="modal-dialog"')).to eql(true)
    expect(rendered.include?('class="modal-content"')).to eql(true)
    expect(rendered.include?('class="modal-header"')).to eql(true)
    expect(rendered.include?('class="modal-body"')).to eql(true)
    expect(rendered.include?('id="modal-invite-label"')).to eql(true)
  end
end
