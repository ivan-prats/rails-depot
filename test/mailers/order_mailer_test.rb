require 'test_helper'

class OrderMailerTest < ActionMailer::TestCase
  test 'received' do
    order = orders(:one)
    mail = OrderMailer.received(order)
    assert_equal "Your Pragmatic order ##{order.id} confirmation", mail.subject
    assert_equal [order.email], mail.to
    assert_equal ['ivanprats@hey.com'], mail.from
    assert_match(/1 x Programming Ruby 1.9/, mail.body.encoded)
  end

  test 'shipped' do
    order = orders(:one)
    mail = OrderMailer.shipped(order)
    assert_equal 'Your Pragmatic order is on its way to you', mail.subject
    assert_equal [order.email], mail.to
    assert_equal ['ivanprats@hey.com'], mail.from
    assert_match(%r{<td>Programming Ruby 1.9</td>}, mail.body.encoded)
  end
end
