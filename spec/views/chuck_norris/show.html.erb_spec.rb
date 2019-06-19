require 'rails_helper'

RSpec.describe "chuck_norris/show", type: :view do
  before(:each) do
    @chuck_norri = assign(:chuck_norri, ChuckNorri.create!(
      :fact => "Fact",
      :knockouts => 2
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Fact/)
    expect(rendered).to match(/2/)
  end
end
