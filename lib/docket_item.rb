require 'ripple'

class DocketItem
  include Ripple::Document
  property :title,        String, :presence => true
  property :description,  String, :presence => true


  def motions
    motions = Riak::MapReduce.new(Ripple.client).add("motions").map(motions_map_reduce, :keep => true).run
    motions.map{|m| instantiate(m) }
  end

  private

  def motions_map_reduce
    <<-JAVASCRIPT
    function(v){
        var results = [];
        var motion = JSON.parse(v.values[0].data);
        if(motion.docket_item_key == '#{self.key}') results.push(motion);
        return results;
    }
    JAVASCRIPT
  end

  def instantiate_from_hash(attrs={})
    attrs.symbolize_keys!
    klass = attrs.delete(:_type).constantize
    klass.new(attrs).tap do |doc|
      doc.instance_variable_set(:@new, false)
      doc.instance_variable_set(:@robject, RObject.new(klass.bucket, attrs[:key]))
    end 
  end

end
