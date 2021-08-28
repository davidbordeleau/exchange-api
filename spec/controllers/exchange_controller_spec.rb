# frozen_string_literal: true

require 'rails_helper'

describe ExchangeController, type: :controller do
  describe '.rate' do
    subject do
      post :rate, params: params
      response
    end

    context 'with good params' do
      let(:params) { { amount: '1', currency_from: 'USD', currency_to: 'CAD' } }
      it 'process the request' do
        expect(subject.status).to eq(200)
      end
    end

    context 'when amount is not specified' do
      let(:params) { { currency_from: 'USD', currency_to: 'CAD' } }
      it 'process the request' do
        expect(subject.status).to eq(200)
      end
    end

    context 'with invalid params' do
      let(:params) { { currency_from: 'US', currency_to: 'CAD' } }
      it 'returns an invalid currency error' do
        response = subject
        expect(JSON.parse(response.body)['error']).to eq('invalid currency')
        expect(response.status).to eq(400)
      end
    end
  end
end
