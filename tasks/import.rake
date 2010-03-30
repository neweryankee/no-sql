desc "Import some docket_item data"
task :import do
  require 'csv'
  CSV.open(File.dirname(__FILE__) + "/../seed-docket_items.csv", 'r').each do |row|
    DocketItem.new(:title => row[0], :description => row[1]).save
  end

end
