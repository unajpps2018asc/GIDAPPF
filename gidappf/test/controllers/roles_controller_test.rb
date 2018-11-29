# Libreria que mantiene la sesion
require 'devise/jwt/test_helpers'

class RolesControllerTest < ActionDispatch::IntegrationTest
  # Libreria que provee de la autenticacion
  include Devise::Test::IntegrationHelpers

  setup do
    @role = roles(:one)
    headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
    @auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, users(:one))
  end

  test "should get index" do
    sign_in users(:one)
    get roles_url, headers: @auth_headers
    assert_response :success
    sign_out :one
  end

  test "should get index_unlogged" do
    get roles_url
    assert_response :found
  end

  test "should get new" do
    get roles_url, headers: @auth_headers
    assert_response :success
  end

  test "should get new_unlogged" do
    get new_role_url
    assert_response :found
  end

  test "should create role" do
    sign_in users(:one)
    assert_difference('Role.count') do
      post roles_url,
        params: { role: {
                    created_at: Time.now,
                    description: 'una descripcion larga de varias palabras',
                    enabled: true,
                    name: 'un nombre' }
                  }
    end
    assert_redirected_to role_url(Role.last)
    sign_out :one
  end

  test "should show role" do
    get role_url(@role), headers: @auth_headers
    assert_response :success
  end

  test "should show role_unlogged" do
    get role_url(@role)
    assert_response :found
  end

  test "should get edit" do
    get role_url(@role), headers: @auth_headers
    assert_response :success
    get "/roles#edit", headers: @auth_headers
    assert_response :success
  end

  test "should get edit_unlogged" do
    get edit_role_url(@role)
    assert_response :found
  end

  test "should update role" do
    sign_in users(:one)
    patch role_url(@role,
      headers: @auth_headers),
      params: {
        role: {
          created_at: Time.rfc3339('1999-12-31T14:00:00-10:00'),
          description: 'Otra descripcion de varias palabras',
          enabled: true,
          name: 'Otro nombre lindo'
        }
      }
    assert_redirected_to  role_url(@role), headers: @auth_headers
    sign_out :one
  end

  # test "should destroy role" do
  #   sign_in users(:one)
  #   p "Cantidad de relaciones:"
  #   p Usercommissionrole.count
  #   @role.created_at= Time.rfc3339('1999-12-31T14:00:00-10:00')
  #   @role.description= 'Otra descripcion de varias palabras'
  #   @role.enabled= true
  #   @role.name= 'Otro nombre lindo'
  #   r1=Role.find_by(name: 'Otro nombre lindo')
  #   Usercommissionrole.find(
  #     Usercommissionrole.where(role_id: r1.id)
  #   ).destroy
  #   assert_difference('Role.count', -1) do
  #     delete role_url(@role), headers: @auth_headers
  #   end
  #
  #   assert_redirected_to roles_url
  #   sign_out :one
  # end
end
