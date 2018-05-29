require 'rails_helper'

RSpec.describe Task, type: :model do
  # Validations
  it { is_expected.to validate_presence_of(:user_id) }
  it { is_expected.to validate_presence_of(:description) }
  it { is_expected.to validate_presence_of(:datetime) }
  it { is_expected.to validate_exclusion_of(:finished).in_array([nil]) }
  it { is_expected.to validate_exclusion_of(:important).in_array([nil]) }
end
