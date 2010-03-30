require 'ripple'

class DocketItem
  include Ripple::Document
  property :title,        String, :presence => true
  property :description,  String, :presence => true


  # Getter for the motions of this docket item
  #   @docket_item.motions
  #
  def motions
    motions = Riak::MapReduce.new(Ripple.client).
      add("motions").
      map(motions_map_function, :keep => true).run

    motions.map{|m| instantiate_from_hash(m) }
  end

  def motions_via_links
    motions = robject.walk(:bucket => "motions").flatten

    motions.map{|m| instantiate(m) }
  end

  private

  # A map function to get the motions given a docket item key
  def motions_map_function
    <<-JAVASCRIPT
    function(v){
        var results = [];
        var motion = JSON.parse(v.values[0].data); motion["key"] = v.key;
        if(motion.docket_item_key == '#{self.key}') results.push(motion);
        return results;
    }
    JAVASCRIPT
  end

  # Mapping a hash to a Ripple::Document
  def instantiate_from_hash(attrs={})
    puts attrs.inspect
    attrs.symbolize_keys!
    raise unless attrs[:_type] and attrs[:key]
    
    klass = attrs.delete(:_type).constantize
    raise unless klass.bucket

    klass.new(attrs).tap do |doc|
      doc.instance_variable_set(:@new, false)
      doc.instance_variable_set(:@robject, Riak::RObject.new(klass.bucket, attrs[:key]))
    end 
  end

  # As seen in Finders
  def instantiate(robject)
    klass = robject.data['_type'].constantize rescue self
    data = {'key' => robject.key}
    data.reverse_merge!(robject.data) rescue data
    klass.new(data).tap do |doc|
      doc.instance_variable_set(:@new, false)
      doc.instance_variable_set(:@robject, robject)
    end
  end
  

end
