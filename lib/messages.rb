require 'terminal-table'
class Messages

  BY_UF = 1.freeze
  BY_CITY = 2.freeze
  BY_FREQ_NAME = 3.freeze

  def initialize
    @table_welcome = set_table_welcome
    @table_queries = set_table_queries
  end
  
  def welcome
    puts @table_welcome
  end

  def select_query
    puts @table_queries
  end

  def message_query_selected(number)
    if number == BY_UF
      puts "\n\nConsulta de Ranking dos nomes mais comuns da UF\n\n"
    elsif number == BY_CITY
      puts "\n\nConsulta de Ranking dos nomes mais comuns da cidade\n\n"
    elsif number == BY_FREQ_NAME
      puts "\n\nFrequência do uso do nome ao longo dos anos\n\n"
    end
  end

  def message_table_name
    space_line
    puts "Ranking dos nomes mais comuns\n"
  end

  def message_table_female_name
    space_line
    puts "Ranking dos nomes femininos mais comuns\n"
  end

  def message_table_male_name
    space_line
    puts "Ranking dos nomes masculinos mais comuns\n"
  end

  def message_end_query
    space_line
    print "Consulta Encerrada"
    space_line
  end

  def space_line
    print "\n\n==================================================\n\n"
  end

  def loading
    puts "Carregando..."
  end

  def invalid_value
    puts "\n\nValor inválido, digite apena um número da tabela\n\n"
  end

  def end_program
    puts "\n\nObrigado por utilizar a aplicação. Até a próxima\n\n"
  end

  def self.type(message)
    print "Digite #{message}: "
  end

  private 

  def set_table_welcome
    rows = []
    rows << ["                     "\
            "Seja Bem-vindo ao Censo-IBGE"\
            "                     "]
    table = Terminal::Table.new(rows: rows)
  end

  def set_table_queries
    rows = []
    headings = []
    headings <<  ['                     Selecione uma consulta                      ']
    rows << ["                     1- Nomes comuns por UF                           "]
    rows << ["                     2- Nomes comuns por cidade                       "]
    rows << ["                     3- Frequência do uso do nome                     "]
    rows << ["                     4- Sair                      "]
    table = Terminal::Table.new(rows: rows, headings: headings)
  end
end