class DocketItem

  include CouchPotato::Persistence

  property :title,       :type => String
  property :description, :type => String

  view :by_title, :key => :title
  view :by_id,    :key => :_id

  validates_presence_of :title

  def motions
    if self._id
      view_spec = Motion.by_docket_item_id( :key => self._id )
      CouchPotato.database.view(view_spec)
    else
      []
    end
  end

end
