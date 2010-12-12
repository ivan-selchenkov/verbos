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

    render :json => { :modos => res }
  end

end
