# frozen_string_literal: true

Rails.application.routes.draw do
  get 'exchange', to: 'exchange#rate'
end
