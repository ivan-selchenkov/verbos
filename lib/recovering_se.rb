#!/usr/bin/env ruby
# coding: utf-8

f = Forma.where("name = ?", 'se').first()
f_el = Forma.where("name = ?", 'él').first()
f_ellos = Forma.where("name = ?", 'ellos').first()

f.palabras.each do |palabra|
  p palabra

  first = palabra.name.split().first()

  if first[-1] == "n"
    palabra.forma = f_ellos
  else
    palabra.forma = f_el
  end
  palabra.name = "se " + palabra.name
  palabra.save!
  p palabra
end
