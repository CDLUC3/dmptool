# frozen_string_literal: true

# == Schema Information
#
# Table name: identifier_schemes
#
#  id                :integer          not null, primary key
#  active            :boolean
#  context           :integer
#  description       :string(255)
#  external_service  :string(255)
#  identifier_prefix :string(255)
#  logo_url          :string(255)
#  name              :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#

# Object that represents a type of identifiaction (e.g. ORCID, ROR, etc.)
class IdentifierScheme < ApplicationRecord
  include FlagShihTzu
  include Subscribable

  ##
  # The maximum length for a name
  NAME_MAXIMUM_LENGTH = 30

  has_many :identifiers

  # ===============
  # = Validations =
  # ===============

  validates :name, uniqueness: { message: UNIQUENESS_MESSAGE },
                   presence: { message: PRESENCE_MESSAGE },
                   length: { maximum: NAME_MAXIMUM_LENGTH }

  validates :active, inclusion: { message: INCLUSION_MESSAGE,
                                  in: BOOLEAN_VALUES }

  # ===========================
  # = Scopes =
  # ===========================

  scope :active, -> { where(active: true) }
  scope :by_name, ->(value) { active.where('LOWER(name) = LOWER(?)', value) }

  ##
  # Define Bit Field values for the scheme's context
  # These are used to determine when and where an identifier scheme is applicable
  #   for_authentication => identifies which schemes can be used for user auth
  #   for_orgs           => identifies which ids will be displayed on Org pages
  #   for_plans          => identifies which ids will be displayed on Plans pages
  #   for_contributors   => identifies which ids will be displayed on Contributor pages
  #   for_identification => identifies which ids are object identifiers (e.g. ROR, ARK, etc.)
  has_flags 1 =>  :for_authentication,
            2 =>  :for_orgs,
            3 =>  :for_plans,
            4 =>  :for_users,
            5 =>  :for_contributors,
            6 =>  :for_identification,
            7 =>  :for_research_outputs,
            column: "context"

  # =========================
  # = Custom Accessor Logic =
  # =========================

  # The name is used by the OrgSearchService as a key. For example:
  #    { "ror": "12345" }
  # so we cannot allow spaces or non alpha characters!
  def name=(value)
    super(value&.downcase&.gsub(/[^a-z]/, ''))
  end

  # ===========================
  # = Instance Methods =
  # ===========================
end
