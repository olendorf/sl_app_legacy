require 'rails_helper'

RSpec.describe "chuck_norris/edit", type: :view do
  before(:each) do
    @chuck_norri = assign(:chuck_norri, ChuckNorri.create!(
      :fact => "MyString",
      :knockouts => 1
    ))
  end

  it "renders the edit chuck_norri form" do
    render

    assert_select "form[action=?][method=?]", chuck_norri_path(@chuck_norri), "post" do

      assert_select "input[name=?]", "chuck_norri[fact]"

      assert_select "input[name=?]", "chuck_norri[knockouts]"
    end
  end
end
