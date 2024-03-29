# frozen_string_literal: true

require 'spec_helper'

RSpec.describe OpsBot::Context, type: :system do
  describe '#build' do
    %i[env secrets utils].each do |context|
      it "loads #{context} and is accessible" do
        expect(described_class.public_send(context)).not_to be_nil
        expect(described_class.public_send(context).class).to eq(OpenStruct)
      end
    end
  end
end
