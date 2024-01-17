require "sinatra"
require "sinatra/reloader"
require "http"
require "json"
require "uri"

def currency_exchange_rates

  exchange_rate_key = ENV.fetch("EXCHANGE_RATE_KEY")

  exchange_rate_url = "http://api.exchangerate.host/list?access_key=#{exchange_rate_key}"

  exchange_rate_data = HTTP.get(exchange_rate_url)
  raw_exchange_data = JSON.parse(exchange_rate_data.to_s)
  exchange_values = raw_exchange_data["currencies"]

  return exchange_values

end

get("/") do
 
    @exchange_symbols = []
    @exchange_symbols = currency_exchange_rates.keys

    erb(:from_currency)

end

get("/:from_currency") do

  @from_currency = params.fetch("from_currency")

  @exchange_symbols = []
  @exchange_symbols = currency_exchange_rates.keys

  erb(:to_currency)

end

get("/:from_currency/:to_currency") do

    @from_currency = params.fetch("from_currency")
    @to_currency = params.fetch("to_currency")

    exchange_rate_key = ENV.fetch("EXCHANGE_RATE_KEY")

    exchange_conversion_url = "http://api.exchangerate.host/convert?access_key=#{exchange_rate_key}&from=#{@from_currency}&to=#{@to_currency}&amount=1"

    extracted_data = JSON.parse(HTTP.get(exchange_conversion_url))

    @convert_value = extracted_data["result"]

    erb(:conversion_results)
    
end
