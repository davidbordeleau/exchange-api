# frozen_string_literal: true

class ExchangeController < ApplicationController
  RATE_EXPIRATION = 1.day

  class InvalidCurrency < ArgumentError; end

  def rate
    rates = fetch_currency_rates.body['rates']
    currency_from = rates[params[:currency_from]]
    currency_to = rates[params[:currency_to]]

    render json: amount_by_currencies(currency_from, currency_to)
  rescue ArgumentError => e
    render json: { error: e.message }, status: 400
  rescue StandardError
    render json: { error: 'An error has occured, please try again later.' }, status: 404
  end

  private

  def fetch_currency_rates
    Rails.cache.fetch('rate_currencies', expires_in: RATE_EXPIRATION) do
      connection.get(ENV.fetch('exchange_rate_url'))
    end
  end

  def connection
    Faraday.new do |faraday|
      faraday.request :json
      faraday.response :json, content_type: /\bjson$/
    end
  end

  def amount_by_currencies(from, to)
    raise InvalidCurrency, 'invalid currency' unless from && to

    amount = params[:amount] || 1
    amount.to_f * (to / from)
  end
end
