#!/usr/bin/env ruby
# coding: utf-8

require 'nokogiri'
require 'open-uri'
require 'builder'


14.times do |index|

  doc = Nokogiri::HTML open(
    'http://www.visuallinklanguages.com/spanish-verbs/group-'+(index+1).to_s,
    "User-Agent" => "Mozilla/5.0 (Windows; U; Windows NT 6.1; ru; rv:1.9.2.3) Gecko/20100401 Firefox/4.0 (.NET CLR 3.5.30729)"
  )


  i = 0
  j = 0
  
  doc.css('div.tdPadding table').each { |table|
    table.css('td').each { |td|
      i += 1
      if i == 4
        i = 0
      end

      next if i != 2
      j += 1
      next if j < 2

      p td.text

    }
  }
end

