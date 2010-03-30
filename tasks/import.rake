desc "Import some docket_item data"
task :import do

  require 'faker'
  docket_item_ids = []
  puts 'Creating DocketItems'
  100.times do
    docket_item = DocketItem.new(
      :title       => Faker::Lorem.sentence,
      :description => Faker::Lorem.paragraph
    )
    docket_item.save
    docket_item_ids << docket_item._id
    print '.'
  end
  puts "\nCreating Motions"
  docket_item_ids.each do |docket_item_id|
    Kernel.rand(10).times do
      motion = Motion.new(
        :title          => Faker::Lorem.sentence,
        :docket_item_id => docket_item_id,
        :yeas           => Kernel.rand(25),
        :nays           => Kernel.rand(25)
      )
      motion.save
      print '.'
    end
  end
  puts "\nDone"
end
