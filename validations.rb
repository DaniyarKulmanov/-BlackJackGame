# frozen_string_literal: true

module Validations
  attr_reader :user, :dealer

  private

  attr_writer :user, :dealer
  attr_accessor :action

  # TODO: not checking triple cards
  def next_round?
    points_above? || draw? || open_cards? || triple_cards_both?
  end

  def bankrupt?
    user.money.zero? || dealer.money.zero?
  end

  def stop_game?
    action.to_i == STOP_GAME || bankrupt?
  end

  def draw?
    user.points == dealer.points
  end

  def points_above?
    user.points > MAX_POINTS || dealer.points > MAX_POINTS
  end

  def triple_cards_both?
    user.cards.size == MAX_CARDS && dealer.cards.size == MAX_CARDS
  end

  def user_cards_not_max?
    user.cards.size < MAX_CARDS
  end

  def both_exceed?
    user.points > MAX_POINTS && dealer.points > MAX_POINTS
  end

  def both_in_limit?
    user.points <= MAX_POINTS && dealer.points <= MAX_POINTS
  end

  def dealer_points_exceed?
    user.points <= MAX_POINTS && dealer.points > MAX_POINTS
  end

  def user_points_exceed?
    dealer.points <= MAX_POINTS && user.points > MAX_POINTS
  end

  def open_cards?
    action.to_i == OPEN_CARDS
  end

  def add_card?
    action.to_i == ADD_CARD
  end

  def user_points_better?
    user.points > dealer.points
  end

  def dealer_points_better?
    user.points < dealer.points
  end
end
