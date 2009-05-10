require File.dirname(__FILE__) + '/../test_helper'

class ChimpHelperTest < Test::Unit::TestCase
  
  
  def setup
    @chimp = ChimpHelper.new
    credentials = fixtures(:mailchimp)
    @auth = @chimp.login(credentials[:username], credentials[:password])
  end
  
  def test_ping_mailchimp
    response = nil
    assert_nothing_raised do
      response = @chimp.ping(@auth) 
    end
    assert !response.blank?
  end
  
  
end