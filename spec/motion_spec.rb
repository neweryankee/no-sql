require File.dirname(__FILE__) + '/spec_helper'

describe Motion do
  let "motion" do
    Motion.new
  end
  it "should have a nil title" do
    motion.title.should be_nil
  end
  it "should have 0 yeas" do
    motion.yeas.should == 0
  end
  it "should have 0 nays" do
    motion.nays.should == 0
  end
  context "more yeas than nays" do
    before do
      motion.yeas = 2
      motion.nays = 1
    end
    it "should have passed?" do
      motion.passed?.should == true
    end
  end
  context "less yeas than nays" do
    before do
      motion.yeas = 1
      motion.nays = 2
    end
    it "should not have passed?" do
      motion.passed?.should == false
    end
  end
  context "equal number of yeas and nays" do
    before do
      motion.yeas = 2
      motion.nays = 2
    end
    it "should not have passed?" do
      motion.passed?.should == false
    end
  end

  
  context "with a blank title" do
    before do
      motion.title = ""
    end
    it "should not be valid" do
      motion.valid?.should == false
    end

    context "saved" do
      before do
        motion.save
      end
      it "should not have an _id" do
        motion._id.should be_nil
      end
    end
  end

  context "with a title" do
    let "title" do
      'my title'
    end
    before do
      motion.title = title
    end
    it "should be valid" do
      motion.valid?.should == true
    end

    context "saved" do
      before do
        motion.save
      end
      it "should have an _id" do
        motion._id.should_not be_nil
      end
    end
  end

end

describe Motion, "#new with attribute Hash" do
  let "attributes" do
    { :title => 'My Title' }
  end
  let "motion" do
    Motion.new(attributes)
  end
  it "should have title from attributes" do
    motion.title.should == attributes[:title]
  end
end

describe Motion, "#by_id" do
  let "view_spec" do
    Motion.by_id
  end
  before do
    @motions = []
    %w(b c a).each do |title|
      motion = Motion.new
      motion.title = title
      CouchPotato.database.save motion
      @motions << motion
    end
  end
  it "should be view" do
    view_spec.should be_a CouchPotato::View::ModelViewSpec
  end
  context "used to find Motions" do
    it "should return an Array of Motions" do
      found = CouchPotato.database.view view_spec
      found.should be_a Array
      found.each {|motion| motion.should be_a Motion }
    end
  end
end

describe Motion, "#by_id with an existing id as key" do
  before do
    @motions = []
    %w(b c a).each do |title|
      motion = Motion.new
      motion.title = title
      CouchPotato.database.save motion
      @motions << motion
    end
  end
  context "used to find DocketItems" do
    it "should turn an Array with one docket_item with that id" do
      motion    = @motions.first
      view_spec = Motion.by_id( :key => motion._id )
      found     = CouchPotato.database.view(view_spec)
      found.should be_a Array
      found.length.should == 1
      found.first.should == motion
    end
  end
end

describe Motion, "#by_title" do
  let "view_spec" do
    Motion.by_title
  end
  it "should be view" do
    view_spec.should be_a CouchPotato::View::ModelViewSpec
  end
  context "used to find Motions" do
    let "found" do
      CouchPotato.database.view view_spec
    end
    before do
      @motions = []
      %w(b c a).each do |title|
        motion = Motion.new
        motion.title = title
        CouchPotato.database.save motion
        @motions << motion
      end
    end
    it "should return an Array of Motions" do
      found.should be_a Array
      found.each {|motion| motion.should be_a Motion }
    end
  end
end

describe Motion, "#by_docket_item_id" do
  let "view_spec" do
    Motion.by_docket_item_id
  end
  it "should be view" do
    view_spec.should be_a CouchPotato::View::ModelViewSpec
  end
end

describe Motion, "#docket_item_id" do
  let "motion" do
    Motion.new
  end
  it "should have nil docket_item" do
    motion.docket_item.should be_nil
  end
  it "should have nil docket_item_id" do
    motion.docket_item_id.should be_nil
  end
  context "set" do
    let "docket_item" do
      di = DocketItem.new(:title => 'My DocketItem')
      di.save
      di
    end
    before do
      motion.docket_item_id = docket_item._id
    end
    it "should have a docket_item that is a DocketItem" do
      motion.docket_item.should_not be_nil
      motion.docket_item.should be_a DocketItem
    end
    it "should have docket_item with corresponding docket_item_id" do
      motion.docket_item_id.should_not be_nil
      motion.docket_item_id.should be_a String
      motion.docket_item_id.should == docket_item.id
    end
  end
end


