require 'ripple'

class DocketItem
  include Ripple::Document
  property :title,        String, :presence => true
  property :description,  String, :presence => true


end
