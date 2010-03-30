require File.dirname(__FILE__) + '/spec_helper'

describe Motion do
  let "motion" do
    Motion.new
  end
  it "should have a nil title" do
    motion.title.should be_nil
  end
  it "should have 0 yeas" do
    motion.yeas.should eq 0
  end
  it "should have 0 nays" do
    motion.nays.should eq 0
  end
  context "more yeas than neas" do
    before do
      motion.yeas = 2
      motion.neas = 1
    end
    it "should have passed?" do
      motion.passed?.should eq true
    end
  end
  context "less yeas than neas" do
    before do
      motion.yeas = 1
      motion.neas = 2
    end
    it "should not have passed?" do
      motion.passed?.should eq false
    end
  end
  context "equal number of yeas and neas" do
    before do
      motion.yeas = 2
      motion.neas = 2
    end
    it "should not have passed?" do
      motion.passed?.should eq false
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


