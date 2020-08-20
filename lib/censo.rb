# frozen_string_literal: true

require './lib/city'
require './lib/uf'
require './lib/name'
require './lib/messages'
require './lib/frequency_names'

# Classe principal do projeto que inicia e roda o fluxo do projeto
class Censo
  attr_reader :messages, :uf

  BY_UF = 1
  BY_CITY = 2
  BY_FREQ_NAME = 3
  EXIT = 4
  LOCAL_URL = 'https://servicodados.ibge.gov.br/api/v1/localidades/estados'
  RANKING_URL = 'https://servicodados.ibge.gov.br/api/v2/censos/nomes/ranking'
  NOMES_URL = 'https://servicodados.ibge.gov.br/api/v2/censos/nomes/'
  CITY = City.new
  MESSAGES = Messages.new
  NAME = Name.new
  UF = Uf.new
  FREQ_NAME = FrequencyNames.new

  # def initialize(input: 0)
  #   input = input
  # end

  def start
    input = 0
    MESSAGES.welcome
    loop do
      MESSAGES.select_query
      Messages.type('um número')
      input = gets.to_i
      query(input)
      break if input == 4
    end
  end

  def query(query)
    case query
    when BY_UF
      MESSAGES.message_query_selected(query)
      query_with_uf
    when BY_CITY
      MESSAGES.message_query_selected(query)
      query_with_city
    when BY_FREQ_NAME
      MESSAGES.message_query_selected(query)
      query_with_frequency_name
    when EXIT
      MESSAGES.end_program
    else
      MESSAGES.invalid_value
    end
  end

  def query_with_uf
    MESSAGES.loading
    input = UF.select_uf_id
    MESSAGES.message_table_name
    NAME.show(local: input)
    MESSAGES.message_table_female_name
    NAME.show(local: input, gender: 'f')
    MESSAGES.message_table_male_name
    NAME.show(local: input, gender: 'm')
    MESSAGES.message_end_query
  end

  def query_with_city
    MESSAGES.loading
    input = UF.select_uf_id
    input = CITY.get_city_id(local: input)
    NAME.show(local: input)
    MESSAGES.message_table_female_name
    NAME.show(local: input, gender: 'f')
    MESSAGES.message_table_male_name
    NAME.show(local: input, gender: 'm')
    MESSAGES.message_end_query
  end

  def query_with_frequency_name
    MESSAGES.space_line
    puts 'AVISO: Não coloque nomes compostos e nem acentos!'
    Messages.type("o/os nome(s) sem espaço e separadas por ',' para consultar")
    input = gets.chomp
    MESSAGES.space_line
    FREQ_NAME.main(NOMES_URL, input)
    MESSAGES.message_end_query
  end
end
