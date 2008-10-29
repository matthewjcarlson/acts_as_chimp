require 'xmlrpc/client'
module MandarinSoda 
  module ChimpCampaign
    class ChimpConfigError < StandardError; end
    class ChimpConnectError < StandardError; end 
    
    def self.included(base) 
      base.extend ActMethods
      mattr_reader :chimp_config
      begin
        @@chimp_config_path =  (RAILS_ROOT + '/config/mail_chimp.yml')
        @@chimp_config = YAML.load_file(@@chimp_config_path)[RAILS_ENV].symbolize_keys            
      end
    end 
    
    module ActMethods 
      def acts_as_chimp_campaign(options = {})
        unless included_modules.include? InstanceMethods 
          class_inheritable_accessor :options 
          extend ClassMethods 
          include InstanceMethods 
        end
        self.options = options 
      end 
      
    end 
    
    module ClassMethods
      
       def search
          auth ||= chimp_login(chimp_config[:username], chimp_config[:password])
       end
      
        def stats(id)
           auth ||= chimp_login(chimp_config[:username], chimp_config[:password])
        end 
        
        def hard_bounces(id, start, limit)
          auth ||= chimp_login(chimp_config[:username], chimp_config[:password])
        end
          
        def soft_bounces(id, start, limit)
          auth ||= chimp_login(chimp_config[:username], chimp_config[:password])
        end
        
        def unsubscribes(id, start, limit)
          auth ||= chimp_login(chimp_config[:username], chimp_config[:password])
        end
    end 
    
    module InstanceMethods 
      def create_campaign
        auth ||= chimp_login(chimp_config[:username], chimp_config[:password])
      end
      
      def update_campaign
        auth ||= chimp_login(chimp_config[:username], chimp_config[:password])
      end  
      
      def resume_campaign
        auth ||= chimp_login(chimp_config[:username], chimp_config[:password])
      end
      
      
      private
      CHIMP_URL = "http://api.mailchimp.com/1.1/" 
      def chimp_login(user, password)
        chimp_api ||= XMLRPC::Client.new2(CHIMP_URL)
        chimp_api.call("login", user, password)
      end
      
      def chimp_subscribe(auth, mailing_list_id, email, merge_vars, email_content_type="html", double_optin=true)
         begin
           chimp_api ||= XMLRPC::Client.new2(CHIMP_URL)
           chimp_api.call("listSubscribe", auth, mailing_list_id, email, merge_vars, email_content_type, double_optin)
         rescue XMLRPC::FaultException => e
           puts e.faultCode
           puts e.faultString
         end    
      end
       
      def chimp_remove(auth, mailing_list_id, email, delete_user=false, send_goodbye=true, send_notify=true)
         chimp_api ||= XMLRPC::Client.new2(CHIMP_URL) 
         chimp_api.call("listUnsubscribe", auth, mailing_list_id, email, delete_user, send_goodbye, send_notify)    
      end
       
      def chimp_info(auth, mailing_list_id, email)
         chimp_api ||= XMLRPC::Client.new2(CHIMP_URL) 
         chimp_api.call("listMemberInfo", auth, mailing_list_id, email)        
      end
       
    end 
  end 
end 
