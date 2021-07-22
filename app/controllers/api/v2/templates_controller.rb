# frozen_string_literal: true

module Api

  module V2

    class TemplatesController < BaseApiController

      before_action -> { doorkeeper_authorize!(:public) }, only: %i[index]

      # GET /api/v2/templates
      # ---------------------
      def index
        templates = Api::V2::TemplatesPolicy::Scope.new(@client).resolve

        templates = templates.sort { |a, b| a.title <=> b.title }
        @items = paginate_response(results: templates)
        render "/api/v2/templates/index", status: :ok
      end

    end

  end

end
