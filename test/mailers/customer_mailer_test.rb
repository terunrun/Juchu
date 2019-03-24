require 'test_helper'

class CustomerMailerTest < ActionMailer::TestCase
  test "accont_activation" do
    mail = CustomerMailer.accont_activation
    assert_equal "Accont activation", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
