require File.dirname(__FILE__) + '/lib/chimp_helper'
ActiveRecord::Base.send(:include, 
                        MandarinSoda::Chimp)
ActiveRecord::Base.send(:include, 
                        MandarinSoda::ChimpCampaign)
