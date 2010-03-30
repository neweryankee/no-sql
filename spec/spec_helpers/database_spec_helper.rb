module DatabaseSpecHelper

  def destroy_all_from(view)
    db = CouchPotato.database
    db.view(view).each { |model| db.destroy model }
  end

end
