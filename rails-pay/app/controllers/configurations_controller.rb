class ConfigurationsController < ApplicationController
  allow_unauthenticated_access

  def ios
    render json: {
      settings: {},
      rules: [
        *modal_rules
      ]
    }
  end

  def android
    render json: {
      settings: {},
      rules: [
        {
          patterns: [
            ".*"
          ],
          properties: {
            context: "default",
            uri: "hotwire://fragment/web",
            pull_to_refresh_enabled: true
          }
        },
        *modal_rules
      ]
    }
  end

  private

  def modal_rules
    [
      {
        patterns: [
          "/new$",
          "/edit$",
          # "/paywall$"
        ],
        properties: {
          context: "modal"
        }
      },
      {
        patterns: ["/session/new"],
        properties: {
          context: "default"
        }
      }
    ]
  end
end
