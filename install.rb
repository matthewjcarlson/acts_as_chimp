require 'fileutils'

chimp_config = File.dirname(__FILE__) + '/../../../config/mail_chimp.yml'
FileUtils.cp File.dirname(__FILE__) + '/mail_chimp.yml.tpl', chimp_config unless File.exist?(chimp_config)
puts IO.read(File.join(File.dirname(__FILE__), 'README'))