class Motion

  include CouchPotato::Persistence

  property :title, :type => String
  property :yeas,  :type => Fixnum, :default => 0
  property :nays,  :type => Fixnum, :default => 0

  view :all, :key => :title

  validates_presence_of :title

  def passed?
    self.yeas > self.nays
  end

  def save
    CouchPotato.database.save self
  end

end

