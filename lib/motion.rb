class Motion

  include CouchPotato::Persistence

  property :title,          :type => String
  property :yeas,           :type => Fixnum, :default => 0
  property :nays,           :type => Fixnum, :default => 0
  property :docket_item_id, :type => String

  view :by_title,          :key => :title
  view :by_id,             :key => :_id
  view :by_docket_item_id, :key => :docket_item_id

  view :total_yeas,
       :map            => "function(doc){ if (doc.yeas > 0) emit(doc._id, doc.yeas); }",
       :reduce         => "function(keys, values){ return sum(values) }",
       :type           => :raw,
       :include_docs   => false,
       :results_filter => lambda {|results| results['rows'].first['value'] }

  validates_presence_of :title

  def passed?
    self.yeas > self.nays
  end

  def docket_item
    if self.docket_item_id
      view_spec    = DocketItem.by_id( :key => self.docket_item_id )
      docket_items = CouchPotato.database.view(view_spec)
      docket_items.first
    end
  end

end

