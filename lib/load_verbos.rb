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
i_tiempo = 0

modos = ['', '', 'Indicativo', 'Subjuntivo', 'Condicional', 'Imperativo']

tiempos = {
  '' => '',
  'Indicativo' => [
    'Presente',
    'Pretérito perfecto',
    'Pretérito imperfecto',
    'Pretérito pluscuamperfecto',
    'Pretérito perfecto simple',
    'Pretérito anterior',
    'Futuro',
    'Futuro perfecto'
  ],
  'Subjuntivo' => [
    'Presente',
    'Pretérito perfecto',
    'Pretérito imperfecto',
    'Pretérito pluscuamperfecto',
    'Futuro',
    'Futuro perfecto'
  ],
  'Condicional' => [
    'Condicional',
    '',
    'Condicional compuesto'
  ],
  'Imperativo' => [
    'Afirmativo',
    'Negativo'
  ]
}

negativo = ['tú', 'él', 'nosotros', 'vosotros', 'ellos']

formas = ['yo', 'tú', 'él', 'nosotros', 'vosotros', 'ellos']



doc.css('table.verbtable td.verbtable').each { |modo|
  i_modo += 1
  next if i_modo < 3 # skip
  next if modos[i_modo - 1].nil?

  i_tiempo = 0

  modo.css('table td').each { |tiempo|
    next if tiempo.text.strip.empty?

    next if tiempos[modos[i_modo - 1]][i_tiempo].empty?

    i_verbo = 1

    p modos[i_modo - 1] + "*****************" + tiempos[modos[i_modo - 1]][i_tiempo]

    forma = ""
    tiempo.css('span').each { |verbo|
      next if verbo.text.strip.empty?

      break if i_verbo > 12

      if i_verbo % 2 == 0
        v = verbo.text

        if modos[i_modo - 1] == 'Imperativo'
          forma = negativo[ (i_verbo / 2) -1 ]
        end

        p forma + " - " + v

      else
        forma = verbo.text
      end
      i_verbo += 1
    }
    i_tiempo += 1
  }

}
