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
end

describe Motion, "#docket_item" do
  let "motion" do
    Motion.new
  end
  it "should be nil" do
    motion.docket_item.should be_nil
  end
end


