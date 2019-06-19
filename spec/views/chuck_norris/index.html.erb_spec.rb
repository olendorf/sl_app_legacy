require 'rails_helper'

RSpec.describe "chuck_norris/index", type: :view do
  before(:each) do
    assign(:chuck_norris, [
      ChuckNorri.create!(
        :fact => "Fact",
        :knockouts => 2
      ),
      ChuckNorri.create!(
        :fact => "Fact",
        :knockouts => 2
      )
    ])
  end

  it "renders a list of chuck_norris" do
    render
    assert_select "tr>td", :text => "Fact".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
  end
end
