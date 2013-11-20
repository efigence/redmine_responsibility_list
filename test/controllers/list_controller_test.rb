require File.expand_path('../../test_helper', __FILE__)

class ListControllerTest < ActionController::TestCase
  # fixtures :projects

  def test_index
    get :index

    assert_response 'success'
    assert_template 'index'
  end
end
