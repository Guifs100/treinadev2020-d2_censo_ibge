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

  def initialize(input: 0)
    @city = City.new
    @frequency_names = FrequencyNames.new
    @input = input
    @uf = Uf.new
    @name = Name.new
    @messages = Messages.new
  end

  def start
    @messages.welcome
    loop do
      @messages.select_query
      Messages.type('um número')
      @input = gets.to_i
      query(@input)
      break if @input == 4
    end
  end

  def query(query)
    case query
    when BY_UF
      @messages.message_query_selected(query)
      query_with_uf
    when BY_CITY
      @messages.message_query_selected(query)
      query_with_city
    when BY_FREQ_NAME
      @messages.message_query_selected(query)
      query_with_frequency_name
    when EXIT
      @messages.end_program
    else
      @messages.invalid_value
    end
  end

  def query_with_uf
    @messages.loading
    @input = @uf.select_uf_id
    @messages.message_table_name
    @name.show(local: @input)
    @messages.message_table_female_name
    @name.show(local: @input, gender: 'f')
    @messages.message_table_male_name
    @name.show(local: @input, gender: 'm')
    @messages.message_end_query
  end

  def query_with_city
    @messages.loading
    @input = @uf.select_uf_id
    @messages.message_table_name
    @input = @city.select_city_id(local: @input)
    @name.show(local: @input)
    @messages.message_table_female_name
    @name.show(local: @input, gender: 'f')
    @messages.message_table_male_name
    @name.show(local: @input, gender: 'm')
    @messages.message_end_query
  end

  def query_with_frequency_name
    @messages.space_line
    puts 'AVISO: Não coloque nomes compostos e nem acentos!'
    Messages.type("o/os nome(s) sem espaço e separadas por ',' para consultar")
    @input = gets.chomp
    @messages.space_line
    @frequency_names.main(NOMES_URL, @input)
    @messages.message_end_query
  end
end
