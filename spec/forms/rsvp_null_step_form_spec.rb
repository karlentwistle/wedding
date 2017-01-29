require 'spec_helper'
require_relative '../../app/forms/rsvp_base_form'
require_relative '../../app/forms/rsvp_null_step_form'

RSpec.describe RsvpNullStepForm do
  subject { described_class.new }

  describe '#save' do
    it 'returns true' do
      expect(subject.save).to be true
    end
  end
end
