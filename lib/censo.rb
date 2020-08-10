require './lib/city'
require './lib/uf'
require './lib/name'
require './lib/messages'
require './lib/frequency_names'
class Censo
  attr_reader :messages, :uf
  attr_accessor :input
  
  BY_UF = 1.freeze
  BY_CITY = 2.freeze
  BY_FREQ_NAME = 3.freeze
  EXIT = 4.freeze
  LOCAL_URL = "https://servicodados.ibge.gov.br/api/v1/localidades/estados"
  RANKING_URL = "https://servicodados.ibge.gov.br/api/v2/censos/nomes/ranking"
  NOMES_URL = "https://servicodados.ibge.gov.br/api/v2/censos/nomes/"

  
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
      print 'Digite um número: '
      @input = gets.to_i
      query(@input)
      if @input == 4
        break
      end
    end
  end

  def query(query)
    if query == BY_UF
      @messages.message_query_selected(query)
      query_with_uf
    elsif query == BY_CITY
      @messages.message_query_selected(query)
      query_with_city
    elsif query == BY_FREQ_NAME
      @messages.message_query_selected(query)
      query_with_frequency_name
    elsif query == EXIT
      puts "\n\nObrigado por utilizar a aplicação. Até a próxima\n\n"
    else
      puts "\n\nValor inválido, digite apena um número da tabela\n\n"
    end
  end

  def query_with_uf
    puts "Carregando..."
    @input = @uf.select_uf_id(LOCAL_URL)
    @messages.message_table_name
    @name.show(base: RANKING_URL, local: @input)
    @messages.message_table_female_name
    @name.show(base: RANKING_URL, local: @input, gender: 'f')
    @messages.message_table_male_name
    @name.show(base: RANKING_URL, local: @input, gender: 'm')
    @messages.message_end_query
  end

  def query_with_city
    puts "Carregando..."
    @input = @uf.select_uf_id(LOCAL_URL)
    @messages.message_table_name
    @input = @city.select_city_id(LOCAL_URL, @input)
    @name.show(base: RANKING_URL, local: @input)
    @messages.message_table_female_name
    @name.show(base: RANKING_URL, local: @input, gender: 'f')
    @messages.message_table_male_name
    @name.show(base: RANKING_URL, local: @input, gender: 'm')
    @messages.message_end_query
  end

  def query_with_frequency_name
    puts "\n==================================================\n\n"
    puts "AVISO: Não coloque nomes compostos e nem acentos!"
    print "Digite o/os nome(s) sem espaço e separadas por ',' para consultar: "
    @input = gets.chomp
    puts "\n==================================================\n"
    @frequency_names.main(NOMES_URL, @input)
    @messages.message_end_query
  end

end