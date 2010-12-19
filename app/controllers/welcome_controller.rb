class WelcomeController < ApplicationController
  def index
  end

  def tiempos

    res = []

    @modos = Modo.find(:all, :order => "id")

    @modos.each do |modo|
      row = []
      modo.tiempos.each do |tiempo|
        row.push({ "name" => tiempo.name, "id" => tiempo.id })
      end
      res.push( { :name => modo.name, :tiempos => row } )
    end

    @formas = Forma.find(:all, :order => "id")

    res_formas = []

    @formas.each do |f|
      res_formas.push({:name => f.name, :id => f.id})
    end

    render :json => { :modos => res, :formas => res_formas }
  end

  def start
    p_tiempos = params[:tiempos]
    p_formas = params[:formas]

    tiempos = p_tiempos.map { |i, v| v }
    formas = p_formas.map { |i, v| v }

    palabras = Palabra.where(:tiempo_id => tiempos).where(:forma_id => formas)

    size = palabras.length

    preguntas = 20.times.map{
      pp = palabras[Random.new.rand(0..size-1)]
      
      while pp.nil? or pp.verb.nil?
        pp = palabras[Random.new.rand(0..size-1)]
      end

      p pp

      {
        :verb => pp.verb.verbo,
        :forma => pp.forma.name,
        :tiempo => pp.tiempo.name,
        :palabra => pp.name
      }
    }

    render :json => { :preguntas => preguntas  }
  end

end
