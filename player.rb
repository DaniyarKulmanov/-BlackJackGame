# frozen_string_literal: true

require_relative 'hand'

class Player
  NAMES = %w[Виталий Борис Иван Петр Данияр Тимур Рустам ДедМороз Вася].freeze

  attr_reader :name, :hand
  attr_accessor :money

  def initialize(name)
    @name = name
    @money = 0
    @hand = Hand.new
  end

  def make_bet
    self.money -= BASE_BET
  end

  private

  attr_writer :name, :hand
end
