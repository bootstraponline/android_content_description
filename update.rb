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
    
    # If there's an ID, use that for content desc.
    ids= data.xpath '//*[@android:id]'
    
    ids.each do | id |
        puts "id #{id.attr('android:id')}"
        if !id.attr(desc).nil?
            puts 'already has desc' if verbose
            next
        end
        
        id_attr = id.attr('android:id')
        
        # Split to get 'id/value'. Easy to differentiate from text and hint.
        id_attr = id_attr.split("+").last
        puts "id #{id_attr}" if verbose
        
        changed = true
        id.set_attribute desc, id_attr
    end
    
    
    if changed # only save xml if we're adding a content description
        count += 1
        puts "#{count} updated #{name}"
        # nokogiri will add xml header if it's missing.
        #<?xml version="1.0" encoding="utf-8"?>
        data = data.to_xml
        File.open(xml, 'w') { |f| f.write( data ) }
    end
    puts "- #{name}" if verbose
end

# You'll want to run "format" using Eclipse and the latest ADT
puts "Finished updating #{count} xml files"
