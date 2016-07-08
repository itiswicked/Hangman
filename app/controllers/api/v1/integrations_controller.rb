module Api
  module V1
    class IntegrationsController < ApplicationController
      skip_before_action :verify_authenticity_token

      def create
        # binding.pry
        hangman = Game.new(params["guess"])
        notifier = Slack::Notifier.new(ENV["SLACK_WEBHOOK_URL"], channel: "#random")
        hangman.update
        notifier.ping(hangman.print)

        render nothing: true
      end
    end
  end
end
