#!/usr/bin/env ruby
$:.unshift(File.dirname(__FILE__) + '/../lib')


require 'test/unit'
require File.dirname(__FILE__) + '/../lib/chimp_helper'
require 'ruby-debug'
require 'activesupport'


module Test
  module Unit
    class TestCase
   
      
   
      
      
      MODEL_FIXTURES = File.dirname(__FILE__) + '/fixtures/'

      def all_fixtures
        @@fixtures ||= load_fixtures
      end
      
      def fixtures(key)
        data = all_fixtures[key] || raise(StandardError, "No fixture data was found for '#{key}'")
        
        data.dup
      end
          
      def load_fixtures
      
        yaml_data = YAML.load(File.read(File.dirname(__FILE__) + '/fixtures.yml'))
        
        model_fixtures = Dir.glob(File.join(MODEL_FIXTURES,'**','*.yml'))
        model_fixtures.each do |file|
          name = File.basename(file, '.yml')
          yaml_data[name] = YAML.load(File.read(file))
        end
        
        symbolize_keys(yaml_data)
      
        yaml_data
      end
      
           
      def symbolize_keys(hash)
        return unless hash.is_a?(Hash)
        
        hash.symbolize_keys!
        hash.each{|k,v| symbolize_keys(v)}
      end
      
    
      
    end
  end
end

