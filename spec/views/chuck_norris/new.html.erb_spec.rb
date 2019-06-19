require 'rails_helper'

RSpec.describe "chuck_norris/new", type: :view do
  before(:each) do
    assign(:chuck_norri, ChuckNorri.new(
      :fact => "MyString",
      :knockouts => 1
    ))
  end

  it "renders new chuck_norri form" do
    render

    assert_select "form[action=?][method=?]", chuck_norris_path, "post" do

      assert_select "input[name=?]", "chuck_norri[fact]"

      assert_select "input[name=?]", "chuck_norri[knockouts]"
    end
  end
end
