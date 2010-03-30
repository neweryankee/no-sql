require File.dirname(__FILE__) + '/spec_helper'

describe DocketItem, "#new" do
  include DatabaseSpecHelper
  let "docket_item" do
    DocketItem.new
  end
  after do
    destroy_all_from(DocketItem.all)
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

describe DocketItem, "#all" do
  include DatabaseSpecHelper

  let "all" do
    DocketItem.all
  end
  it "should be view" do
    all.should be_a CouchPotato::View::ModelViewSpec
  end
  context "used to find DocketItems" do
    let "found" do
      CouchPotato.database.view all
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
    after do
      destroy_all_from(DocketItem.all)
    end
    it "should return an Array of DocketItems" do
      found.should be_a Array
    end
    it "should order elements by title" do
      (1..found.length-1).each do |index|
        found[index-1].title.should <= found[index].title
      end
    end
  end
end

describe DocketItem, "#motions" do
  let "docket_item" do
    DocketItem.new
  end
  it "should have none" do
    pending
    docket_item.motions.should be_a Array
    docket_item.motions.should be_empty
  end
end

