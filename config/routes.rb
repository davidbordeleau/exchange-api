# frozen_string_literal: true

Rails.application.routes.draw do
  post 'exchange', to: 'exchange#rate'
end
