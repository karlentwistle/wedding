require 'spec_helper'
require_relative '../../app/forms/rsvp_base_form'

RSpec.describe RsvpBaseForm do
  let(:cookies) { nil }
  let(:params) { {} }
  subject { described_class.new(cookies: cookies, params: params) }

  describe '#persisted?' do
    it 'returns false' do
      expect(subject.persisted?).to be false
    end
  end

  describe '#viewable?' do
    it 'returns true' do
      expect(subject.viewable?).to be true
    end
  end

  describe '#finish_early?' do
    it 'returns false' do
      expect(subject.finish_early?).to be false
    end
  end

  describe '#save' do
    it 'raises not implement error' do
      expect {
        subject.save
      }.to raise_error(NotImplementedError)
    end
  end

  describe '#cookie_payload' do
    it 'returns empty hash' do
      expect(subject.cookie_payload).to eql({})
    end
  end

  describe 'initialization' do
    context 'params' do
      let(:klass) do
        Class.new(RsvpBaseForm) do
          attr_accessor :foo
        end
      end
      let(:params) { { foo: :bar } }
      it 'writes each key pair value' do
        expect(klass.new(params: params).foo).to eql(:bar)
      end
    end
  end
end
