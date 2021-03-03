# frozen_string_literal: true

class Player
  attr_reader :name, :cards
  attr_accessor :money

  def initialize(name)
    @name = name
    @cards = {}
    @money = 0
  end

  private

  attr_writer :name
end
