require 'test_helper'

class CommissionsControllerTest < ActionDispatch::IntegrationTest
  # Libreria que provee de la autenticacion
  include Devise::Test::IntegrationHelpers

  setup do
    @commission = commissions(:one)
    headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
    @auth_h_commission = Devise::JWT::TestHelpers.auth_headers(headers, users(:one))
  end

  test "should get index" do
    # sign_in users(:one)
    get commissions_url, headers: @auth_h_commission
    assert_response :success
    # sign_out :one
  end

  test "should get index_unlogged" do
    get commissions_url
    assert_response :found
  end

  test "should get new" do
    # sign_in users(:one)
    get commissions_url, headers: @auth_h_commission
    assert_response :success
    # sign_out :one
  end

  test "should get new_unlogged" do
    get new_commission_url
    assert_response :found
  end

  test "should create commission" do
    sign_in users(:one)
    assert_difference('Commission.count') do
      post commissions_url,
        params: {
          commission: {
            description: "Descripcion de prueba para la comision",
            end_date: Time.rfc3339('2032-12-31T14:00:00-10:00'),
            name: "Una comision",
            start_date: Time.rfc3339('2031-12-31T14:00:00-10:00')
            }
          }
      end
    com=Commission.last
    assert_redirected_to time_sheets_associate_path commission_id: com.id.to_s, commission_name: com.name, notice: 'Commission was successfully created.'
    sign_out :one
  end

  test "should show commission" do
    # sign_in users(:one)
    get commission_url(@commission), headers: @auth_h_commission
    assert_response :success
    # sign_out :one
  end

  test "should get edit" do
    # sign_in users(:one)
    @commission.description="A second commission"
    @commission.end_date=Time.rfc3339('2032-12-31T14:00:00-10:00')
    @commission.name="Commission two"
    @commission.start_date=Time.rfc3339('2031-12-31T14:00:00-10:00')

    get commission_url(@commission), headers: @auth_h_commission
    assert_response :success
    get "/commissions#edit", headers: @auth_h_commission
    assert_response :success
    # sign_out :one
  end

  test "should update commission" do
    sign_in users(:one)
    patch commission_url(@commission),
      params: {
          commission: {
            description: @commission.description,
            end_date: @commission.end_date,
            name: @commission.name,
            start_date: Time.now
            }
          }
    sign_out :one
  end

  test "should destroy commission" do
    sign_in users(:one)
    @commission.description="A second commission"
    @commission.end_date=Time.rfc3339('2032-12-31T14:00:00-10:00')
    @commission.name="Commission two"
    @commission.start_date=Time.rfc3339('2031-12-31T14:00:00-10:00')
    @commission.save

    c1=Usercommissionrole.joins(:commission).find_by(commission: @commission).destroy
    assert_difference('Commission.count', -1) do
      delete commission_url(@commission), headers: @auth_h_commission
    end

    assert_response :no_content
    sign_out :one
  end
end
