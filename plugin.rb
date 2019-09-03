# name: discourse-eauth
# about: Authenticate with Eauth
# version: 0.1.1
# author: Sirius Tsou
# url: https://github.com/pelith/discourse-eauth

enabled_site_setting :eauth_enabled
enabled_site_setting :eauth_site
enabled_site_setting :eauth_authorize_url
enabled_site_setting :eauth_token_url
enabled_site_setting :eauth_client_id
enabled_site_setting :eauth_client_secret

gem 'omniauth-eauth-oauth2', '1.0.1'

class Auth::EauthAuthenticator < Auth::ManagedAuthenticator

  def name
    "eauthoauth2"
  end

  def enabled?
    SiteSetting.eauth_enabled
  end

  def register_middleware(omniauth)
    omniauth.provider :EauthOauth2,
           setup: lambda { |env|
              strategy = env["omniauth.strategy"]
              strategy.options[:client_options][:site] = SiteSetting.eauth_site
              strategy.options[:client_options][:authorize_url] = SiteSetting.eauth_authorize_url
              strategy.options[:client_options][:token_url] = SiteSetting.eauth_token_url
              strategy.options[:client_id] = SiteSetting.eauth_client_id
              strategy.options[:client_secret] = SiteSetting.eauth_client_secret
           }
  end

  def description_for_user(user)
    info = UserAssociatedAccount.find_by(provider_name: name, user_id: user.id)&.info
    return "" if info.nil?

    info["address"] || ""
  end

  def after_authenticate(auth_token, existing_account: nil)
    auth_token[:extra] = {}
    super
  end
end

auth_provider frame_width: 920,
              frame_height: 800,
              authenticator: Auth::EauthAuthenticator.new,
              icon: "fab-ethereum"

register_svg_icon "fab-ethereum" if respond_to?(:register_svg_icon)

register_css <<CSS
.btn-social.eauthoauth2 {
  background: #c99d66;
}
CSS
