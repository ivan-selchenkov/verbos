#!/usr/bin/env ruby
# coding: utf-8

require 'nokogiri'
require 'open-uri'
require 'builder'


doc = Nokogiri::HTML open(
  'http://www.verbix.com/webverbix/Spanish/tener.html',
  "User-Agent" => "Mozilla/5.0 (Windows; U; Windows NT 6.1; ru; rv:1.9.2.3) Gecko/20100401 Firefox/4.0 (.NET CLR 3.5.30729)"
)

i_modo = 0

formas = ['yo', 'tú', 'él', 'nosotros', 'vosotros', 'ellos']

doc.css('table.verbtable td.verbtable').each { |modo|
  i_modo += 1
  next if i_modo < 3
  modo.css('table td').each { |tiempo|
    i_verbo = 1
    forma = ""
    tiempo.css('span').each { |verbo|
      next if verbo.text.strip.empty?

      if i_verbo % 2 == 0
        v = verbo.text
        p forma + " - " + v
      else
        forma = verbo.text
      end
      i_verbo += 1
    }
  }

}
