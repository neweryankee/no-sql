class DocketItem

  include CouchPotato::Persistence

  property :title,       :type => String
  property :description, :type => String

  view :all, :key => :title

  validates_presence_of :title

  def save
    CouchPotato.database.save self
  end

end
