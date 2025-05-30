require "test_helper"

class PredictionsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get new_prediction_url
    assert_response :success
  end

  test "should get create" do
    post create_prediction_url
    assert_response :success
  end

  test "should get result" do
    get prediction_result_url
    assert_response :success
  end
end
