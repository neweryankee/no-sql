require 'couch_potato'
CouchPotato::Config.database_name = "http://127.0.0.1:5984/open_docket"

Dir.glob(File.join(File.dirname(__FILE__), 'lib', '**', '*.rb')).each {|f| require f }

