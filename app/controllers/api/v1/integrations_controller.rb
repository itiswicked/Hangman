module Api
  module V1
    class IntegrationsController < ApplicationController
      skip_before_action :verify_authenticity_token
      before_action :create_notifier

      def new
        hangman = Game.new
        @notifier.ping(hangman.draw)

        render nothing: true
      end

      def create
        if incoming_slack_message_authorized?
          hangman = Game.start_round(params[:text])
          hangman.update
          @notifier.ping(hangman.draw)
        else
          @notifier.ping("Whoops! Unathorized access.")
        end
        render nothing: true
      end

      private

      def create_notifier
        @notifier = Slack::Notifier.new(ENV["SLACK_WEBHOOK_URL"], channel: "#random")
      end

      def incoming_slack_message_authorized?
        params[:token] == ENV['INCOMING_SLACK_MESSAGE_TOKEN']
      end
    end
  end
end
