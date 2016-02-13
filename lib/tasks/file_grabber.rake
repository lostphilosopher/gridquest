require 'open-uri'
namespace :file_grabber do
  desc 'Go through each file in assets/json/ and pull the images at the urls listed'
  task grab_from_json: :environment do
    ['box', 'npc'].each do |i|
      ds = Description.read_from_json(i)
      ds.each do |d|
        f = open(d['url'])
        FileUtils.cp f, "app/assets/images/#{i}/#{d['name'].gsub(/[^0-9a-z]/i, '')}.jpg"
      end
    end
  end
end
