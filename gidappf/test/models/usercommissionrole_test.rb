require 'test_helper'

class UsercommissionroleTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "references" do
    assert_equal(usercommissionroles(:one).user_id, users(:one).id, "Se testea referencia de usuario")
    assert_equal(usercommissionroles(:one).role_id, roles(:one).id, "Se testea referencia de rol")
    assert_equal(usercommissionroles(:one).commission_id, commissions(:one).id, "Se testea referencia de comision")
    assert_equal(usercommissionroles(:two).user_id, users(:two).id, "Se testea referencia de usuario")
    assert_equal(usercommissionroles(:two).role_id, roles(:two).id, "Se testea referencia de rol")
    assert_equal(usercommissionroles(:two).commission_id, commissions(:two).id, "Se testea referencia de comision")
  end

  test "relations update" do
    usercommissionroles(:one).update(user: users(:two))
    assert_equal(usercommissionroles(:one).user_id, users(:two).id, "Se testea referencia de cambio de usuario")
    usercommissionroles(:one).update(commission: commissions(:two))
    assert_equal(usercommissionroles(:one).commission_id, commissions(:two).id, "Se testea referencia de comision")
    usercommissionroles(:one).update(role: roles(:two))
    assert_equal(usercommissionroles(:one).role_id, roles(:two).id, "Se testea referencia de rol")
    usercommissionroles(:two).update(user: users(:one))
    assert_equal(usercommissionroles(:two).user_id, users(:one).id, "Se testea referencia de cambio de usuario")
    usercommissionroles(:two).update(role: roles(:one))
    assert_equal(usercommissionroles(:two).role_id, roles(:one).id, "Se testea referencia de rol")
    usercommissionroles(:two).update(commission: commissions(:one))
    assert_equal(usercommissionroles(:two).commission_id, commissions(:one).id, "Se testea referencia de comision")
  end

end
