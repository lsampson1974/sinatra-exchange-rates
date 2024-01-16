require "sinatra"
require "sinatra/reloader"
require "http"
require "json"
require "uri"

exchange_rate_key = ENV.fetch("EXCHANGE_RATE_KEY")

exchange_rate_url = "http://api.exchangerate.host/list?access_key=#{exchange_rate_key}"


exchange_rate_data = HTTP.get(exchange_rate_url)
raw_exchange_data = JSON.parse(exchange_rate_data.to_s)
exchange_key_value = raw_exchange_data["currencies"]

get("/") do
 
    @exchange_symbols = []
    @exchange_symbols = exchange_key_value.keys


    erb(:from_currency)

end

get("/:from_currency") do

  @from_currency = params.fetch("from_currency")

  @exchange_symbols = []
  @exchange_symbols = exchange_key_value.keys

  erb(:to_currency)

end

get("/:from_currency/:to_currency") do

    @from_currency = params.fetch("from_currency")
    @to_currency = params.fetch("to_currency")

    exchange_conversion_url = "http://api.exchangerate.host/convert?access_key=#{exchange_rate_key}&from=#{@from_currency}&to=#{@to_currency}&amount=1"

    extracted_data = JSON.parse(HTTP.get(exchange_conversion_url), object_class: OpenStruct)

    @convert_value = extracted_data.result

    erb(:conversion_results)
    
end
