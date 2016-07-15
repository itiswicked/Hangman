module Api
  module V1
    class IntegrationsController < ApplicationController
      skip_before_action :verify_authenticity_token
      before_action :create_notifier
      before_action :verify_slack_token, only: [:create]

      def new
        hangman = Game.new
        @notifier.ping(hangman.draw)

        render nothing: true
      end

      def create
        hangman = Game.start_round(params['text'])
        hangman.update
        @notifier.ping(hangman.draw)

        render nothing: true
      end

      private

      def create_notifier
        @notifier = Slack::Notifier.new(ENV["SLACK_WEBHOOK_URL"], channel: "#random")
      end

      def verify_slack_token
        if params['token'] == ENV['INCOMING_SLACK_MESSAGE_TOKEN']
          true
        else
          # render nothing: true, status: 401 ?
        end
      end
    end
  end
end
