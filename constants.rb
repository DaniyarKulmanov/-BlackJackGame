# frozen_string_literal: true

NAMES = %w[Виталий Борис Иван Петр Данияр Тимур Рустам ДедМороз Вася].freeze
ASK_NAME = 'Введите Ваше имя'
BASE_MONEY = 100
PLAYER_ACTIONS = ['0 - ⌛ Пропустить ход️',
                  '1 - 🤏 Добавить карту',
                  '2 - 🔥 Открыть карты'].freeze
SUITS = %w[♠️ ♣️ ♥️ ♦️].freeze
PIC_CARDS = %w[Туз Король Дама Валет].freeze
ACE = 'Туз'
NUM_CARDS = (2..10).freeze
LINE = '=' * 40
FIRST_ROUND = 1
OPEN_CARDS = 2
ROUND_COUNT = 1
EXIT_MENU = ['♠️ ♣️ ♥️ ♦️ Конец игры ♠️ ♣️ ♥️ ♦️',
             'Нажмите 1 - 🔥 Новая игра!',
             'Покинуть игру, любая клавиша'].freeze
