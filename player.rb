# frozen_string_literal: true

class Player
  NAMES = %w[Виталий Борис Иван Петр Данияр Тимур Рустам ДедМороз Вася].freeze

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
