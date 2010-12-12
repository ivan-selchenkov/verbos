#!/usr/bin/env ruby
# coding: utf-8

require 'nokogiri'
require 'open-uri'
require 'builder'
require 'uri'


verbos = []

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

      verbos.push(td.text.strip)

    }
  }
end

verbos.each do |verbo|

  v = Verb.find_by_verbo verbo

  unless v

    v = Verb.new

    v.verbo = verbo

    v.save!

    enc_uri = URI.escape('http://www.verbix.com/webverbix/Spanish/' + verbo + '.html')

    doc = Nokogiri::HTML open(
      enc_uri,
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
        'Condicional compuesto',
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

      m = Modo.find_by_name(modos[i_modo - 1])
      unless m
        m = Modo.new
        m.name = modos[i_modo - 1]
        m.save!
      end

      modo.css('table td').each { |tiempo|
        next if tiempo.text.strip.empty?

        next if tiempos[modos[i_modo - 1]][i_tiempo].empty?

        t_name = tiempos[modos[i_modo - 1]][i_tiempo]

        i_verbo = 1

        p modos[i_modo - 1] + "*****************" + t_name

        t = Tiempo.where({:name => t_name, :modo_id => m}).first

        unless t
          t = Tiempo.new
          t.name = t_name
          t.modo = m
          t.save!
        end

        i = Irregular.where({:verb_id => v, :tiempo_id => t}).first

        unless i
          i = Irregular.new
          i.verb = v
          i.tiempo = t
          i.irregular = 0
          i.save!
        end

        forma = ""
        tiempo.css('span').each { |verbo|
          next if verbo.text.strip.empty?

          break if i_verbo > 12



          if i_verbo % 2 == 0

            if verbo.attributes['class'].value == "irregular"
              i.irregular = 1
            end

            v_name = verbo.text

            if modos[i_modo - 1] == 'Imperativo'
              forma = negativo[ (i_verbo / 2) -1 ]
            end

            p forma + " - " + v_name

            f = Forma.find_by_name forma

            unless f
              f = Forma.new
              f.name = forma
              f.save!
            end

            p = Palabra.new

            p.verb = v
            p.tiempo = t
            p.forma = f
            p.name = v_name

            p.save!

          else
            forma = verbo.text
          end
          i_verbo += 1
        }
        i.save!
        i_tiempo += 1
      }

    }
  end
end