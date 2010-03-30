require 'ripple'

class Motion
  include Ripple::Document
  property :title,  String, :presence => true
  property :yeas,   Integer, :default => 0
  property :nays,   Integer, :default => 0
  property :docket_item_key,  String

  def passed?
    yeas > nays
  end

  def docket_item
    DocketItem.find(docket_item_key) if docket_item_key
  end

end
