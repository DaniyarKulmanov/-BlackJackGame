# frozen_string_literal: true

NAMES = %w[Виталий Борис Иван Петр Данияр Тимур Рустам ДедМороз Вася].freeze
ASK_NAME = 'Введите Ваше имя'
BASE_MONEY = 100
PLAYER_ACTIONS = ['Введите любое значение и нажмите ENTER чтобы пропустить ход️ ⏳',
                  '1 - 🤏 Добавить карту',
                  '2 - 🔥 Открыть карты',
                  '3 - 🔥 Выход из игры'].freeze
SUITS = %w[♠️ ♣️ ♥️ ♦️].freeze
PIC_CARDS = %w[Туз Король Дама Валет].freeze
ACE = 'Туз'
NUM_CARDS = (2..10).freeze
LINE = '=' * 40
INITIAL_VALUE = 0
FIRST_ROUND = 1
NEW_GAME = 1
ADD_CARD = 1
OPEN_CARDS = 2
STOP_GAME = 3
MAX_POINTS = 21
DEALER_POINTS = 17
BASE_BET = 10
ROUND_COUNT = 1
EXIT_MENU = ['♠️ ♣️ ♥️ ♦️ Игра законечна! ♠️ ♣️ ♥️ ♦️',
             'Нажмите 1 - 🔥 Новая игра!',
             'Введите любое значение и нажмите ENTER для завершение игры 😟'].freeze
INFORMATION = ['Введите любое значение и нажмите ENTER для продолжения'].freeze
USER_COMMANDS = /^[1-3]$/.freeze
DRAW = 'Ничья'
