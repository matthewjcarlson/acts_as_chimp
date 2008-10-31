require 'xmlrpc/client'
module MandarinSoda 
  module ChimpCampaign
    class ChimpConfigError < StandardError; end
    class ChimpConnectError < StandardError; end 
    
    def self.included(base) 
      base.extend ActMethods
      mattr_reader :chimp_config, :auth
      begin
        @@chimp_config_path =  (RAILS_ROOT + '/config/mail_chimp.yml')
        @@chimp_config = YAML.load_file(@@chimp_config_path)[RAILS_ENV].symbolize_keys
        @@auth ||= chimp_login(@@chimp_config[:username], @@chimp_config[:password])                   
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
      def campaigns
          
      end
      
      def stats(id)
        chimp_campaign_stats(id)
      end 
        
      def hard_bounces(id, start, limit)
        chimp_campaign_hard_bounces(id, start, limit)
      end
          
      def soft_bounces(id, start, limit)
        chimp_campaign_soft_bounces(id, start, limit)
      end
        
      def unsubscribed(id, start, limit)
        chimp_campaign_unsubscribed(id, start, limit)
      end
      
      def abuse(id, start, limit)

      end
      
      def folders()

      end
      
    end 
    
    module InstanceMethods 
      def create_campaign
      
      end
      
      def update_campaign(campaign_id, name, options)
    
      end  
      
      def resume(campaign_id)
        chimp_resume_campaign(campaign_id)
      end
    
      def pause(campaign_id)
        chimp_pause_campaign(campaign_id)
      end
      
      def unschedule
        
      end
      
      def content(campaign_id)

      end
      
      def schedule(campaign_id, time, group_b_time)
        chimp_campaign_schedule(campaign_id, time, group_b_time)
      end
      
      def send_now(campaign_id)
        chimp_send_campaign(campaign_id)
      end
      
      def send_test(campaign_id)
        chimp_send_campaign(campaign_id)
      end
      
      private
      CHIMP_URL = "http://api.mailchimp.com/1.1/"
      CHIMP_API = XMLRPC::Client.new2(CHIMP_URL) 
      def chimp_login(user, password)
        CHIMP_API.call("login", user, password)
      end
      
      def chimp_create_campaign(mailing_list_id, type, opts)
         CHIMP_API.call("listMemberInfo", auth, mailing_list_id)        
      end
      
      def chimp_pause_campaign(campaign_id)
        CHIMP_API.call("campaignPause", auth, campaign_id )        
      end
      
      def chimp_resume_campaign(campaign_id)
        CHIMP_API.call("campaignResume", auth, campaign_id)        
      end
      
       def chimp_resume_campaign(campaign_id)
          CHIMP_API.call("campaignResume", auth, campaign_id)        
        end
      
      def chimp_send_campaign(campaign_id)
        CHIMP_API.call("campaignSendNow", auth, campaign_id)        
      end
      
      def chimp_send_campaign_test(campaign_id)
        CHIMP_API.call("campaignSendTest", auth, campaign_id)        
      end
      
      def chimp_campaign_stats(campaign_id)
        CHIMP_API.call("campaignStats", auth, campaign_id)    
      end
      
      def chimp_campaign_hard_bounces(campaign_id, start=0, limit=100) 
        CHIMP_API.call("campaignHardBounces", auth, campaign_id)    
      end
      
      def chimp_campaign_soft_bounces(campaign_id, start=0, limit=100)
        CHIMP_API.call("campaignSoftBounces", auth, campaign_id)    
      end
      
      def chimp_campaign_unsubscribed(campaign_id, start=0, limit=100)
        CHIMP_API.call("campaignUnsubscribes", auth, campaign_id)    
      end
      
      def chimp_campaign_schedule(campaign_id, time, time_b)
        CHIMP_API.call("campaignSchedule", auth, campaign_id, time, time_b)    
      end
         
    end 
  end 
end 
