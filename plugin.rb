# name: discourse-eauth
# about: Authenticate with Eauth
# version: 0.1
# author: Sirius Tsou
# url: https://github.com/pelith/discourse-eauth

enabled_site_setting :eauth_auth_enabled
enabled_site_setting :eauth_client_id
enabled_site_setting :eauth_client_secret

gem 'omniauth-eauth-oauth2', '1.0.0'

class Auth::EauthAuthenticator < Auth::ManagedAuthenticator

  def name
    "eauthoauth2"
  end

  def enabled?
    SiteSetting.eauth_auth_enabled
  end

  def register_middleware(omniauth)
    omniauth.provider :EauthOauth2,
           setup: lambda { |env|
             strategy = env["omniauth.strategy"]
              strategy.options[:client_id] = SiteSetting.eauth_client_id
              strategy.options[:client_secret] = SiteSetting.eauth_client_secret
           }
  end

  def description_for_user(user)
    info = UserAssociatedAccount.find_by(provider_name: name, user_id: user.id)&.info
    return "" if info.nil?

    info["name"] || info["email"] || ""
  end

  def after_authenticate(auth_token, existing_account: nil)
    # auth_token[:extra] = {}
    super
  end
end

auth_provider frame_width: 920,
              frame_height: 800,
              authenticator: Auth::EauthAuthenticator.new

register_svg_icon "fab fa-ethereum" if respond_to?(:register_svg_icon)

register_css <<CSS
.btn-social.eauthoauth2 {
  background: #46698f;
}
CSS
