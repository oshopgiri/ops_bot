require 'spec_helper'

RSpec.describe OpsBot::Job::Build, type: :job do
  let(:client_klass) { OpsBot::Build::ZIP }
  let(:s3_client_klass) { OpsBot::Integration::AWS::S3 }

  before do
    allow(OpsBot::Context.env.build).to receive(:type).and_return('zip')
  end

  after do
    described_class.execute
  end

  describe '#perform' do
    context 'when build is already present' do
      before do
        allow_any_instance_of(s3_client_klass).to receive(:file_exists?).and_return(true)
      end

      it 'skips build creation' do
        expect_any_instance_of(client_klass).not_to receive(:package)
        expect_any_instance_of(s3_client_klass).not_to receive(:upload_file)
      end
    end

    context 'when build is not present' do
      before do
        allow_any_instance_of(client_klass).to receive(:build_exists?).and_return(true)
        allow_any_instance_of(s3_client_klass).to receive(:file_exists?).and_return(false, true)
      end

      it 'creates and uploads a build' do
        expect_any_instance_of(client_klass).to receive(:package)
        expect_any_instance_of(s3_client_klass).to receive(:upload_file)
      end

      context 'when build creation fails' do
        before do
          allow_any_instance_of(client_klass).to receive(:build_exists?).and_return(false)
        end

        it 'skips build upload' do
          expect_any_instance_of(client_klass).to receive(:package)
          expect_any_instance_of(s3_client_klass).not_to receive(:upload_file)
        end
      end
    end
  end
end
