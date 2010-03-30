require File.dirname(__FILE__) + '/spec_helper'

describe DocketItem do
  let "docket_item" do
    DocketItem.new
  end

  it "should have a nil title" do
    docket_item.title.should be_nil
  end
  it "should have a nil description" do
    docket_item.description.should be_nil
  end
end

describe DocketItem, "#motions" do
  let "docket_item" do
    DocketItem.new
  end
  it "should have none" do
    docket_item.motions.should be_a Array
    docket_item.motions.should be_empty
  end
end

