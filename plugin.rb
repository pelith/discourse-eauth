# name: discourse-eauth
# about: Authenticate with Eauth
# version: 0.1
# author: Sirius Tsou
# url: https://github.com/pelith/discourse-eauth

enabled_site_setting :eauth_enabled

gem 'omniauth-eauth-oauth2', '1.0.0'

class Auth::EauthAuthenticator < Auth::ManagedAuthenticator

  def name
    "eauth"
  end

  def enabled?
    SiteSetting.eauth_enabled
  end

  def register_middleware(omniauth)
    omniauth.provider :EauthOauth2,
           setup: lambda { |env|
             strategy = env["omniauth.strategy"]
              strategy.options[:scope] = 'email'
           }
  end

  def description_for_user(user)
    info = UserAssociatedAccount.find_by(provider_name: name, user_id: user.id)&.info
    return "" if info.nil?

    info["name"] || info["email"] || ""
  end

  def after_authenticate(auth_token, existing_account: nil)
    # Ignore extra data (we don't need it)
    auth_token[:extra] = {}
    super
  end
end

auth_provider frame_width: 920,
              frame_height: 800,
              authenticator: Auth::EauthAuthenticator.new

register_svg_icon "fab fa-eauth" if respond_to?(:register_svg_icon)

register_css <<CSS
.btn-social.eauth {
  background: #46698f;
}
CSS
