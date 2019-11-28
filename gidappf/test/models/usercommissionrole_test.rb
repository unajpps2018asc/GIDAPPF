require 'test_helper'

class UsercommissionroleTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "references" do
    assert_equal(usercommissionroles(:test).user_id, users(:user_test_full_access).id, "Se testea referencia de usuario")
    assert_equal(usercommissionroles(:test).role_id, roles(:anyrole).id, "Se testea referencia de rol")
    assert_equal(usercommissionroles(:test).commission_id, commissions(:incoming).id, "Se testea referencia de comision")
    assert_equal(usercommissionroles(:ucr_ingress_disable).user_id, users(:anyuser).id, "Se testea referencia de usuario")
    assert_equal(usercommissionroles(:ucr_ingress_disable).role_id, roles(:ingress_disable).id, "Se testea referencia de rol")
    assert_equal(usercommissionroles(:ucr_ingress_disable).commission_id, commissions(:students_one).id, "Se testea referencia de comision")
  end

  test "relations update" do
    usercommissionroles(:test).update(user: users(:anyuser))
    assert_equal(usercommissionroles(:test).user_id, users(:anyuser).id, "Se testea referencia de cambio de usuario")
    usercommissionroles(:test).update(commission: commissions(:students_one))
    assert_equal(usercommissionroles(:test).commission_id, commissions(:students_one).id, "Se testea referencia de comision")
    usercommissionroles(:test).update(role: roles(:ingress_disable))
    assert_equal(usercommissionroles(:test).role_id, roles(:ingress_disable).id, "Se testea referencia de rol")
    usercommissionroles(:ucr_ingress_disable).update(user: users(:user_test_full_access))
    assert_equal(usercommissionroles(:ucr_ingress_disable).user_id, users(:user_test_full_access).id, "Se testea referencia de cambio de usuario")
    usercommissionroles(:ucr_ingress_disable).update(role: roles(:anyrole))
    assert_equal(usercommissionroles(:ucr_ingress_disable).role_id, roles(:anyrole).id, "Se testea referencia de rol")
    usercommissionroles(:ucr_ingress_disable).update(commission: commissions(:incoming))
    assert_equal(usercommissionroles(:ucr_ingress_disable).commission_id, commissions(:incoming).id, "Se testea referencia de comision")
  end

end
