require 'spec'
require File.join(File.dirname(__FILE__), '..', 'open_docket')
require File.join(File.dirname(__FILE__), 'spec_helpers', 'database_spec_helper')

Spec::Runner.configure do |config|

  config.include DatabaseSpecHelper

  config.before(:all) do
  end

  config.after(:all) do
    destroy_all_from(DocketItem.by_id)
    destroy_all_from(Motion.by_id)
  end

  config.before(:each) do
  end

  config.after(:each) do
  end

end

