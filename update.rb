require 'rubygems'
require 'nokogiri'

# Must update dir for this to work.
dir = '/path/to/res/layout/**/*.xml'

def desc; 'android:contentDescription'; end
count = 0

Dir.glob dir do | xml |
  xml  = File.expand_path xml
  data = Nokogiri::XML File.read(xml), nil, 'UTF-8'

  # If there's a hint, use that for content desc.
  hints = data.xpath '//*[@android:hint]'
  
  changed = false

  hints.each do | hint |
    changed = true
    hint.set_attribute desc, hint.attr('android:hint')
  end

  # Prefer text over hint for content desc.
  texts = data.xpath '//*[@android:text]'

  texts.each do | text |
    change = true
    text.set_attribute desc, text.attr('android:text')
  end
  
  if changed # only save xml if we're adding a content description
    count += 1
    puts "#{count} updated #{xml}"
    # nokogiri will add xml header if it's missing.
    # <?xml version="1.0" encoding="utf-8"?>
    data = data.to_xml
    File.open(xml, 'w') { |f| f.write( data ) }
  end
end

# You'll want to run "format" using Eclipse and the latest ADT
puts "Finished updating #{count} xml files"
