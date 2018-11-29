require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @john = User.new(
      email: 'john@example.com',
      encrypted_password: Devise::Encryptor.digest(User, 'One_passw0rd!'),
      created_at: Time.rfc3339('1999-12-31T14:00:00-10:00'),
      updated_at: Time.now
    )

    @john2 = User.new(
      email: 'johnTwo@example.com',
      encrypted_password: Devise::Encryptor.digest(User, 'Two_passw0rd!'),
      created_at: Time.rfc3339('1999-12-31T14:00:00-10:00'),
      updated_at: Time.now
    )

  end

  test 'valid users' do
    assert @john.email.present?,"Campo email ok"
    assert_equal(users(:one).email,@john.email,"Testeo del usuario one del fixture, con datos correctos")
    assert @john.created_at.present?,"Campo creado el dia..  ok"
    assert_equal(users(:one).created_at,@john.created_at,"Testeo del usuario one del fixture, con datos correctos")
    assert @john.encrypted_password.present?,"Campo password encriptado  ok"
    assert_not_equal(users(:one).encrypted_password,@john.encrypted_password,"desigualdad de seguridad: el encPass no es el pass")
    u1 = @john.email.present? && User.find_by(email: @john.email)
    assert u1.valid_password?('One_passw0rd!')
    # assert @john.valid?

    assert @john2.email.present?,"Campo email ok"
    assert_equal(users(:two).email,@john2.email,"Testeo del usuario two del fixture, con datos correctos")
    assert @john2.created_at.present?,"Campo creado el dia..  ok"
    assert_equal(users(:two).created_at,@john2.created_at,"Testeo del usuario two del fixture, con datos correctos")
    assert @john2.encrypted_password.present?,"Campo password encriptado  ok"
    assert_not_equal(users(:two).encrypted_password,@john2.encrypted_password,"desigualdad de seguridad: el encPass no es el pass")
    u2 = @john2.email.present? && User.find_by(email: @john2.email)
    assert u2.valid_password?('Two_passw0rd!')
    # assert @john.valid?
  end

  test 'cross password' do
    assert_not_equal(users(:one).encrypted_password,@john2.encrypted_password,"desigualdad de seguridad con datos correctos")
    u3 = @john.email.present? && User.find_by(email: @john.email)
    assert_not u3.valid_password?('Two_passw0rd!')

    assert_not_equal(users(:two).encrypted_password,@john.encrypted_password,"desigualdad de seguridad con datos correctos")
    assert @john2.encrypted_password.present?
    u4 = @john2.email.present? && User.find_by(email: @john2.email)
    assert_not u4.valid_password?('One_passw0rd!')
  end

  test 'error dataentries' do
    @john.email=nil
    assert_not_equal(users(:one).email,@john.email,"Testeo del usuario one del fixture, con datos faltantes")
    @john.created_at='zzz'
    assert_not_equal(users(:one).created_at,@john.created_at,"Testeo del usuario one del fixture, con datos incorrectos")
    @john.encrypted_password="Campo password encriptado  ok"
    assert_not_equal(users(:one).encrypted_password,@john.encrypted_password,"desigualdad de seguridad: el encPass no es el pass")
    u1 = @john.email.present? && User.find_by(email: @john.email)
    assert_not u1

    @john2.email="Campo email ok"
    assert_not_equal(users(:two).email,@john2.email,"Testeo del usuario two del fixture, con datos incorrectos")
    @john2.created_at=nil
    assert_not_equal(users(:two).created_at,@john2.created_at,"Testeo del usuario two del fixture, con datos faltantes")
    @john2.encrypted_password=nil
    assert_nil(@john2.encrypted_password,"encPass faltante")
    u2 = @john2.email.present? && User.find_by(email: @john2.email)
    assert_not u2
  end

end
