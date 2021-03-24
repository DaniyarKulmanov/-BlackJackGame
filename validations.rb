# frozen_string_literal: true

module Validations
  ADD_CARD = '1'
  OPEN_CARDS = '2'
  STOP_GAME = '3'
  MAX_POINTS = 21
  MAX_CARDS = 3

  attr_reader :user, :dealer
  attr_accessor :action

  private

  attr_writer :user, :dealer

  def bankrupt?
    user.money.zero? || dealer.money.zero?
  end

  def stop_game?
    action == STOP_GAME || bankrupt?
  end

  def draw?
    user.hand.points == dealer.hand.points
  end

  def both_exceed?
    user.hand.points > MAX_POINTS && dealer.hand.points > MAX_POINTS
  end

  def both_in_limit?
    user.hand.points <= MAX_POINTS && dealer.hand.points <= MAX_POINTS
  end

  def dealer_points_exceed?
    user.hand.points <= MAX_POINTS && dealer.hand.points > MAX_POINTS
  end

  def user_points_exceed?
    dealer.hand.points <= MAX_POINTS && user.hand.points > MAX_POINTS
  end

  def open_cards?
    action == OPEN_CARDS
  end

  def add_card?
    action == ADD_CARD
  end

  def user_points_better?
    user.hand.points > dealer.hand.points
  end

  def dealer_points_better?
    user.hand.points < dealer.hand.points
  end
end
