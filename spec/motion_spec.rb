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
        CouchPotato.database.save motion
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
        CouchPotato.database.save motion
      end
      it "should have an _id" do
        motion._id.should_not be_nil
      end
    end
  end

end

describe Motion, "#all" do
  include DatabaseSpecHelper

  let "all" do
    Motion.all
  end
  it "should be view" do
    all.should be_a CouchPotato::View::ModelViewSpec
  end
  context "used to find Motions" do
    let "found" do
      CouchPotato.database.view all
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
    after do
      destroy_all_from(Motion.all)
    end
    it "should return an Array of Motions" do
      found.should be_a Array
    end
    it "should order elements by title" do
      (1..found.length-1).each do |index|
        found[index-1].title.should <= found[index].title
      end
    end
  end
end

describe Motion, "#docket_item" do
  let "motion" do
    Motion.new
  end
  it "should be nil" do
    pending
    motion.docket_item.should be_nil
  end
end


