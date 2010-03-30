require 'ripple'

class Motion
  include Ripple::Document
  property :title,  String, :presence => true
  property :yeas,   Integer, :default => 0
  property :nays,   Integer, :default => 0
  property :docket_item_key,  String

  after_save :create_links

  # Did the motion pass?
  def passed?
    yeas > nays
  end

  # This gets the docket item based on the key
  def docket_item
    DocketItem.find(docket_item_key) if docket_item_key
  end

  private

  def create_links
    if self.key && self.docket_item_key
      self.robject.links << Riak::Link.new("/riak/docket_items/#{self.docket_item_key}", "docket_item")
      self.robject.store

      d = docket_item
      d.send(:robject).links << Riak::Link.new("/riak/motions/#{self.key}", "motions")
      d.send(:robject).store
    end
  end

end
