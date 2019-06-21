require 'rails_helper'

RSpec.describe "static_pages/home.html.erb", type: :view do
  it 'says home' do
    render
    expect(rendered).to have_css('h1', text: 'StaticPages#home')
  end 
end
