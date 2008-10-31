require 'xmlrpc/client'
module MandarinSoda 
  module ChimpCampaign
    class ChimpConfigError < StandardError; end
    class ChimpConnectError < StandardError; end 
    
    def self.included(base) 
      base.extend ActMethods
      mattr_reader :chimp_config, :auth
      CHIMP_URL = "http://api.mailchimp.com/1.1/"
      CHIMP_API = XMLRPC::Client.new2(CHIMP_URL)
      
      begin
        @@chimp_config_path =  (RAILS_ROOT + '/config/mail_chimp.yml')
        @@chimp_config = YAML.load_file(@@chimp_config_path)[RAILS_ENV].symbolize_keys
        @@auth ||= CHIMP_API.call("login", @@chimp_config[:username], @@chimp_config[:password])                   
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
        chimp_campaign_abuse_reports(id, start, limit)
      end
      
      def folders
        chimp_campaign_folders
      end
      
      private
      def chimp_campaign_abuse_reports(campaign_id, start=0, limit=100)
          CHIMP_API.call("campaignAbuseReports", auth, self.campaign_id)        
      end
      
      def chimp_campaign_stats(campaign_id)
        CHIMP_API.call("campaignStats", auth, campaign_id)    
      end

      def chimp_campaign_hard_bounces(campaign_id, start=0, limit=100) 
        CHIMP_API.call("campaignHardBounces", auth, campaign_id, start, limit)    
      end

      def chimp_campaign_soft_bounces(campaign_id, start=0, limit=100)
        CHIMP_API.call("campaignSoftBounces", auth, campaign_id, start, limit)    
      end
      
      def chimp_campaign_unsubscribed(campaign_id, start=0, limit=100)
        CHIMP_API.call("campaignUnsubscribes", auth, campaign_id, start, limit)    
      end
      
      def chimp_campaign_folders
        CHIMP_API.call("campaignFolder", auth)    
      end
      
    end 
    
    module InstanceMethods 
      def create_campaign
      
      end
      
      def update_campaign(options={})
        chimp_update_campaign(options)
      end  
      
      def resume
        chimp_resume_campaign
      end
    
      def pause
        chimp_pause_campaign
      end
      
      def unschedule
        chimp_campaign_unschedule
      end
      
      def content
        chimp_campaign_content
      end
      
      def schedule(time, group_b_time)
        chimp_campaign_schedule(time, group_b_time)
      end
      
      def send_now
        chimp_send_campaign
      end
      
      def send_test
        chimp_send_campaign
      end
      
      private

      def chimp_create_campaign(mailing_list_id, type, opts)
         CHIMP_API.call("listMemberInfo", auth, mailing_list_id)        
      end
      
      def chimp_update_campaign(opts)
        CHIMP_API.call("listMemberInfo", auth, self.campaign_id, self.name, opts)        
      end
      
      def chimp_pause_campaign
        CHIMP_API.call("campaignPause", auth, self.campaign_id )        
      end
      
      def chimp_resume_campaign
        CHIMP_API.call("campaignResume", auth, self.campaign_id)        
      end
      
      def chimp_send_campaign
        CHIMP_API.call("campaignSendNow", auth, self.campaign_id)        
      end
      
      def chimp_send_campaign_test
        CHIMP_API.call("campaignSendTest", auth, self.campaign_id)        
      end
      
      def chimp_campaign_schedule(time, time_b)
        CHIMP_API.call("campaignSchedule", auth, self.campaign_id, time, time_b)    
      end
      
      def chimp_campaign_unschedule
        CHIMP_API.call("campaignUnschedule", auth, self.campaign_id)    
      end
      
      def chimp_campaign_content
          CHIMP_API.call("campaignContent", auth, self.campaign_id)        
      end
      
      
    end 
  end 
end 
