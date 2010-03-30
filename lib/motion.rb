require 'ripple'

class Motion
  include Ripple::Document
  property :title,  String, :presence => true
  property :yeas,   Integer, :default => 0
  property :nays,   Integer, :default => 0
  property :docket_item_key,  String

  # Did the motion pass?
  def passed?
    yeas > nays
  end

  # This gets the docket item based on the key
  def docket_item
    DocketItem.find(docket_item_key) if docket_item_key
  end

end
