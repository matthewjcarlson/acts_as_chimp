
require 'xmlrpc/client'

class ChimpAuthorizationError < StandardError; end

class ChimpHelper
  def login(user, password)
    chimp_api ||= XMLRPC::Client.new2("http://www.mailchimp.com/admin/api/1.0/index.phtml") 
    chimp_api.call("login", user, password)
  end
   
  def all_mailing_lists(auth)
    raise ChimpAuthorizationError("Please log in and make sure you have a valid auth id") if (auth.nil?) 
    chimp_api ||= XMLRPC::Client.new2("http://www.mailchimp.com/admin/api/1.0/index.phtml")
    chimp_api.call("lists", auth)    
  end

  def mailing_list_info(auth, mailing_list_name)
    mailing_lists = all_mailing_lists(auth)
    unless mailing_lists.nil?  
      mailing_lists.find { |list| list["name"] = mailing_list_name }
    end
  end 
    
  def mailing_list_members(auth, mailing_list_id, member_status)
    raise ChimpAuthorizationError("Please log in and make sure you have a valid auth id.") if (auth.nil?) 
    chimp_api = XMLRPC::Client.new2("http://www.mailchimp.com/admin/api/1.0/index.phtml") 
    chimp_api.call("listMembers", auth, mailing_list_id, member_status)    
  end
end