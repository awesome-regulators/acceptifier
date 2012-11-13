require 'spec_helper'

describe "projects/new" do
  before(:each) do
    assign(:project, stub_model(Project,
      :rally_id => 1,
      :name => "MyString"
    ).as_new_record)
  end

  it "renders new project form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => projects_path, :method => "post" do
      assert_select "input#project_rally_id", :name => "project[rally_id]"
      assert_select "input#project_name", :name => "project[name]"
    end
  end
end
