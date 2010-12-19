#!/usr/bin/env ruby
# coding: utf-8

formas = [ 'me', 'te', 'os', 'nos' ]

formas_new = {
  'me' => 'yo',
  'te' => 'tú',
  'os' => 'vosotros',
  'nos' => 'nosotros'
}

formas.each do |forma|
  f = Forma.where("name = ?", forma).first()
  f_new = Forma.where("name = ?", formas_new[forma]).first()

  f.palabras.each do |palabra|
    p palabra
    palabra.name = f.name + " " + palabra.name
    palabra.forma = f_new
    palabra.save!
    p palabra
  end

end