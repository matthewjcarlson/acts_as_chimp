
require 'xmlrpc/client'

class ChimpAuthorizationError < StandardError; end

class ChimpHelper
   CHIMP_URL = "http://api.mailchimp.com/1.0/" 
  def login(user, password)
    raise ChimpAuthorizationError("Please provide a valid user and password") if (user.nil? || password.nil?) 
    chimp_api = XMLRPC::Client.new2(CHIMP_URL) 
    chimp_api.call("login", user, password)
  end
   
  def all_mailing_lists(auth)
    raise ChimpAuthorizationError("Please log in and make sure you have a valid auth id") if (auth.nil?) 
    chimp_api = XMLRPC::Client.new2(CHIMP_URL)
    chimp_api.call("lists", auth)    
  end

  def mailing_list_info(auth, mailing_list_name)
    mailing_lists = all_mailing_lists(auth)
    unless mailing_lists.nil?  
      mailing_lists.find { |list| list["name"] == mailing_list_name }
    end
  end 
    
  def mailing_list_members(auth, mailing_list_id, member_status)
    raise ChimpAuthorizationError("Please log in and make sure you have a valid auth id.") if (auth.nil?) 
    chimp_api = XMLRPC::Client.new2(CHIMP_URL) 
    chimp_api.call("listMembers", auth, mailing_list_id, member_status)    
  end
end