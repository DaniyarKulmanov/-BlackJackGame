# frozen_string_literal: true

class Player
  attr_reader :name
  attr_accessor :money, :cards, :points

  def initialize(name)
    @name = name
    @cards = []
    @money = 0
    @points = 0
  end

  private

  attr_writer :name
end
