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
    associated_account = UserAssociatedAccount.find_by(provider_name: name, user_id: user.id)
    return "" if associated_account.nil?
    description_for_auth_hash(associated_account) || I18n.t("associated_accounts.connected")
  end

  def description_for_auth_hash(auth_token)
    return if auth_token&.info.nil?
    info = auth_token.info
    info["address"]
  end

  def after_authenticate(auth_token, existing_account: nil)
    # Try and find an association for this account
    association = UserAssociatedAccount.find_or_initialize_by(provider_name: auth_token[:provider], provider_uid: auth_token[:uid])

    # Reconnecting to existing account
    if can_connect_existing_user? && existing_account && (association.user.nil? || existing_account.id != association.user_id)
      association.user = existing_account
    end

    association.info = auth_token[:info] || {}
    association.credentials = auth_token[:credentials] || {}
    association.extra = auth_token[:extra] || {}

    association.last_used = Time.zone.now

    # Save to the DB. Do this even if we don't have a user - it might be linked up later in after_create_account
    association.save!

    # Build the Auth::Result object
    result = Auth::Result.new
    info = auth_token[:info]
    result.omit_username = true

    result.email = info[:address]+'@ethmail.cc'
    result.name = ''

    # check ens
    ens = auth_token[:extra][:raw_info][:ens]
    if ens
      result.username = ens
    else 
      result.username = info[:address]
    end

    result.extra_data = {
      provider: auth_token[:provider],
      uid: auth_token[:uid]
    }
    result.user = association.user

    result
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

