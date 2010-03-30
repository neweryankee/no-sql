require File.dirname(__FILE__) + '/spec_helper'

describe DocketItem, "#new" do
  let "docket_item" do
    DocketItem.new
  end
  it "should have a nil title" do
    docket_item.title.should be_nil
  end
  it "should have a nil description" do
    docket_item.description.should be_nil
  end
  it "should not have an _id" do
    docket_item._id.should be_nil
  end

  context "with a blank title" do
    before do
      docket_item.title = ""
    end
    it "should not be valid" do
      docket_item.valid?.should == false
    end

    context "saved" do
      before do
        docket_item.save
      end
      it "should not have an _id" do
        docket_item._id.should be_nil
      end
    end
  end

  context "with a title" do
    let "title" do
      'my title'
    end
    before do
      docket_item.title = title
    end
    it "should be valid" do
      docket_item.valid?.should == true
    end

    context "saved" do
      before do
        docket_item.save
      end
      it "should have an _id" do
        docket_item._id.should_not be_nil
      end
    end
  end

end

describe DocketItem, "#new with attribute Hash" do
  let "attributes" do
    { :title => 'My Title', :description => 'My Description' }
  end
  let "docket_item" do
    DocketItem.new(attributes)
  end
  it "should have title from attributes" do
    docket_item.title.should == attributes[:title]
  end
  it "should have description from attributes" do
    docket_item.description.should == attributes[:description]
  end
end

describe DocketItem, "#by_id" do
  let "view_spec" do
    DocketItem.by_id
  end
  before do
    @docket_items = []
    %w(b c a).each do |title|
      docket_item = DocketItem.new
      docket_item.title = title
      CouchPotato.database.save docket_item
      @docket_items << docket_item
    end
  end
  it "should be view" do
    view_spec.should be_a CouchPotato::View::ModelViewSpec
  end
  context "used to find DocketItems" do
    it "should return an Array of DocketItems" do
      found = CouchPotato.database.view view_spec
      found.should be_a Array
      found.each {|docket_item| docket_item.should be_a DocketItem }
    end
  end
end

describe DocketItem, "#by_id with an existing id as key" do
  before do
    @docket_items = []
    %w(b c a).each do |title|
      docket_item = DocketItem.new
      docket_item.title = title
      CouchPotato.database.save docket_item
      @docket_items << docket_item
    end
  end
  context "used to find DocketItems" do
    it "should turn an Array with one docket_item with that id" do
      docket_item = @docket_items.first
      view_spec   = DocketItem.by_id( :key => docket_item._id )
      found       = CouchPotato.database.view(view_spec)
      found.should be_a Array
      found.length.should == 1
      found.first.should == docket_item
    end
  end
end


describe DocketItem, "#by_title" do
  let "view_spec" do
    DocketItem.by_title
  end
  it "should be view" do
    view_spec.should be_a CouchPotato::View::ModelViewSpec
  end
  context "used to find DocketItems" do
    let "found" do
      CouchPotato.database.view view_spec
    end
    before do
      @docket_items = []
      %w(b c a).each do |title|
        docket_item = DocketItem.new
        docket_item.title = title
        CouchPotato.database.save docket_item
        @docket_items << docket_item
      end
    end
    it "should return an Array of DocketItems" do
      found.should be_a Array
      found.each {|docket_item| docket_item.should be_a DocketItem }
    end
  end
end

describe DocketItem, "#motions" do
  let "docket_item" do
    di = DocketItem.new(:title => 'My DocketItem')
    di.save
    di
  end
  it "should have none" do
    docket_item.motions.should be_a Array
    docket_item.motions.should be_empty
  end
  context "with Motions that have docket_item's id" do
    let "associated_motions" do
      %w(b c a).inject([]) do |memo, title|
        motion = Motion.new(:title => title, :docket_item_id => docket_item._id)
        motion.save
        memo << motion
      end
    end
    let "unassociated_motions" do
      %w(b c a).inject([]) do |memo, title|
        motion = Motion.new(:title => title)
        motion.save
        memo << motion
      end
    end
    before do
      associated_motions
      unassociated_motions
    end
    it "should have associated_motions in motions" do
      associated_motions.each {|motion| docket_item.motions.should include motion }
    end
    it "should not have unassociated_motions in motions" do
      unassociated_motions.each {|motion| docket_item.motions.should_not include motion }
    end
  end
end

