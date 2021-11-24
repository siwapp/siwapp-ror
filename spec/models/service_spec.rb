require 'rails_helper'

RSpec.describe Service, :type => :model do
  let(:klass) { described_class }

  describe "#validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:value) }
    it { is_expected.to validate_numericality_of(:value) }
  end

  it "must be active and not default by default" do
    service = Service.create!(name: 'service_name', value: '12')
    expect(service).to be_valid
    expect(service.active).to be true
    expect(service.default).to be false
  end

  it "can't be deleted if an item has the service" do
    service = Service.create!(name: 'service_name', value: '12')
    Item.create!(services: [service])
    expect(service.destroy).to be false
  end
end
