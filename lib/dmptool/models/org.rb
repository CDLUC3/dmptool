# frozen_string_literal: true

module Dmptool

  module Models

    module Org

      extend ActiveSupport::Concern

      class_methods do

        # DMPTool participating institution helpers
        def participating
          self.includes(identifiers: :identifier_scheme)
              .where(managed: true).order(:name)
        end

      end

      included do

        def shibbolized?
          identifier_for_scheme(scheme: "shibboleth").present?
        end

      end

    end

  end

end
