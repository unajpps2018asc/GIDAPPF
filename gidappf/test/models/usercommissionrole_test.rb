require 'test_helper'

class UsercommissionroleTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "references" do
    assert_equal(usercommissionroles(:one).user_id, users(:user_test_full_access).id, "Se testea referencia de usuario")
    assert_equal(usercommissionroles(:one).role_id, roles(:anyrole).id, "Se testea referencia de rol")
    assert_equal(usercommissionroles(:one).commission_id, commissions(:incoming).id, "Se testea referencia de comision")
    assert_equal(usercommissionroles(:two).user_id, users(:anyuser).id, "Se testea referencia de usuario")
    assert_equal(usercommissionroles(:two).role_id, roles(:ingress_disable).id, "Se testea referencia de rol")
    assert_equal(usercommissionroles(:two).commission_id, commissions(:students_one).id, "Se testea referencia de comision")
  end

  test "relations update" do
    usercommissionroles(:one).update(user: users(:anyuser))
    assert_equal(usercommissionroles(:one).user_id, users(:anyuser).id, "Se testea referencia de cambio de usuario")
    usercommissionroles(:one).update(commission: commissions(:students_one))
    assert_equal(usercommissionroles(:one).commission_id, commissions(:students_one).id, "Se testea referencia de comision")
    usercommissionroles(:one).update(role: roles(:ingress_disable))
    assert_equal(usercommissionroles(:one).role_id, roles(:ingress_disable).id, "Se testea referencia de rol")
    usercommissionroles(:two).update(user: users(:user_test_full_access))
    assert_equal(usercommissionroles(:two).user_id, users(:user_test_full_access).id, "Se testea referencia de cambio de usuario")
    usercommissionroles(:two).update(role: roles(:anyrole))
    assert_equal(usercommissionroles(:two).role_id, roles(:anyrole).id, "Se testea referencia de rol")
    usercommissionroles(:two).update(commission: commissions(:incoming))
    assert_equal(usercommissionroles(:two).commission_id, commissions(:incoming).id, "Se testea referencia de comision")
  end

end
