require 'rubygems'
require 'nokogiri'

# Must update dir for this to work.
dir = '/path/to/res/layout/**/*.xml'

def desc; 'android:contentDescription'; end
count = 0

verbose = false

Dir.glob dir do | xml |
  name = File.basename(xml)
  puts "+ #{name}" if verbose

  xml  = File.expand_path xml
  data = Nokogiri::XML File.read(xml), nil, 'UTF-8'
  changed = false

  # If there's a hint, use that for content desc.
  hints = data.xpath '//*[@android:hint]'
  
  changed = false

  hints.each do | hint |
    existing = hint.attr(desc)
    if !hint.attr(desc).nil?
      puts 'already has desc' if verbose
      next
    end

    hint_attr = hint.attr('android:hint')
    puts "hint #{hint_attr}" if verbose

    changed = true
    hint.set_attribute desc, hint_attr
  end

  # Prefer text over hint for content desc.
  texts = data.xpath '//*[@android:text]'

  texts.each do | text |
    puts "text #{text.attr('android:text')}"
    if !text.attr(desc).nil?
      puts 'already has desc' if verbose
      next
    end

    text_attr = text.attr('android:text')
    puts "text #{text_attr}" if verbose

    changed = true
    text.set_attribute desc, text_attr
  end
  
  if changed # only save xml if we're adding a content description
    count += 1
    puts "#{count} updated #{name}"
    # nokogiri will add xml header if it's missing.
    # <?xml version="1.0" encoding="utf-8"?>
    data = data.to_xml
    File.open(xml, 'w') { |f| f.write( data ) }
  end
  puts "- #{name}" if verbose
end

# You'll want to run "format" using Eclipse and the latest ADT
puts "Finished updating #{count} xml files"
