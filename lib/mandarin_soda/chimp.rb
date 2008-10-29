require 'xmlrpc/client'
module MandarinSoda 
  module Chimp
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
      def acts_as_chimp(options = {})
        unless included_modules.include? InstanceMethods 
          class_inheritable_accessor :options 
          extend ClassMethods 
          include InstanceMethods 
        end
        
        if options[:mailing_list_id].nil?
          raise ChimpConfigError, 'A mailing list id is required to subscribe a user.  See README.'
        end
        
        self.options = options 
        after_create :add_to_mailing_list
        after_destroy :remove_from_mailing_list
      end 
      
    end 
    
    module ClassMethods 
    end 
    
    module InstanceMethods 
      def add_to_mailing_list
        auth ||= chimp_login(chimp_config[:username], chimp_config[:password])
        chimp_subscribe(auth, options[:mailing_list_id], self.email, mail_merge_arguments)
      end
      
      def remove_from_mailing_list
        auth ||= chimp_login(chimp_config[:username], chimp_config[:password])
        chimp_remove(auth, options[:mailing_list_id], self.email)
      end  
      
      def mailing_list_info
        auth ||= chimp_login(chimp_config[:username], chimp_config[:password])
        chimp_info(auth, options[:mailing_list_id], self.email)
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
        def mail_merge_arguments
          unless options[:mail_merge].blank?
            merge_args = {}
            options[:mail_merge].each_pair do  |key, value|
              merge_args[key] = self.send(value) 
            end
          end
        end
    end 
  end 
end 
