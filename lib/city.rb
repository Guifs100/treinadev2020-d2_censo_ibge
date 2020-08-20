# frozen_string_literal: true

require 'faraday'
require 'json'
require 'terminal-table'
require './lib/messages'

# Classe onde controla as cidades e retorna uma cidade
class City
  LOCAL_URL = 'https://servicodados.ibge.gov.br/api/v1/localidades/estados'
  MESSAGES = Messages.new

  def get_city_id(local: nil)
    city_id = []
    response = Faraday.get("#{LOCAL_URL}/#{local}/municipios")
    response_body = JSON.parse(response.body, symbolize_names: true)
    table = show_cities(response_body)
    loop do
      Messages.type('o NÚMERO DA OPÇÃO da Cidade que deseja buscar os nomes comuns')
      input = -1 + gets.to_i
      city_id = select_city(response_body, input)
      break unless city_id[2].nil?

      MESSAGES.invalid_value
      puts table
    end
    MESSAGES.space_line
    puts "\n\nBuscando Tabelas de ranking dos nomes comuns em #{city_id[2]}"
    city_id[1]
  end

  def select_city(response_body, input)
    aux = []
    if input >= 0 && input < response_body.count
      aux << input
      aux << response_body[input][:id]
      aux << response_body[input][:nome]
    end
    aux
  end

  def show_cities(response_body)
    rows = []
    headings = []
    cont = 1
    headings << ['Opção', 'Nome da Cidade']
    response_body.each do |city|
      rows << [cont, city[:nome]]
      cont += 1
    end
    table = Terminal::Table.new(rows: rows, headings: headings)
    puts table
    table
  end
end
