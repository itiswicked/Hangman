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
        hangman = Game.start_round(params["guess"])
        hangman.update
        @notifier.ping(hangman.draw)

        render nothing: true
      end

      private

      def create_notifier
        @notifier = Slack::Notifier.new(ENV["SLACK_WEBHOOK_URL"], channel: "#random")
      end
    end
  end
end
