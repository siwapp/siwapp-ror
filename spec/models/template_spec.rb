require "rails_helper"

RSpec.describe Template, :type => :model do
  it "must have a name" do
    template = Template.new(template: 'hello!')
    expect(template).not_to be_valid
  end

  it "must have a template" do
    template = Template.new(name: 'nice!')
    expect(template).not_to be_valid
  end
end
