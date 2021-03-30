# Eauth Authentication Plugin

This plugin adds support for logging in to a Discourse site via Eauth.

## Installation

1. Follow the directions at [Install a Plugin](https://meta.discourse.org/t/install-a-plugin/19157) using https://github.com/pelith/discourse-eauth as the repository URL. (use `git clone https://github.com/pelith/discourse-eauth.git --branch ENS` for `app.yml` if you want to use ENS as username)
2. Rebuild the app using `./launcher rebuild app`
3. In your Discourse instance, go to Site Settings, filter by "Eauth".
4. Check the "eauth enabled" checkbox, and you're done!

## Integration

1. Install [discourse-eauth](https://github.com/pelith/discourse-eauth) plugin by following this [guide](https://meta.discourse.org/t/install-plugins-in-discourse/19157).

2. Enable the plugin at `/admin/site_settings/category/plugins`.
![Setup Plugin](https://user-images.githubusercontent.com/16600750/64149783-63c57c80-ce16-11e9-92f1-693eb0a70680.png)
![Configs](https://user-images.githubusercontent.com/16600750/64155221-e7d13180-ce21-11e9-9ae8-0644a81d85a0.png)

3. Set max username length up to 42. Remember to setup username change period if you're allowing users to edit their username instead of using the address they registered.
![username length](https://user-images.githubusercontent.com/16600750/64155052-9a54c480-ce21-11e9-92a7-fbe6e08befff.png)
![edit username](https://user-images.githubusercontent.com/16600750/64159073-26b6b580-ce29-11e9-80a8-abc1235ae46a.png)

4. [Setup OAuth client](https://github.com/pelith/node-eauth-server#3-setup-oauth-clients), insert `client_id` and `client_secret` set in step 2 to `oauth_clients` table of [node-eauth-server](https://github.com/pelith/node-eauth-server) and use `http://your_discourse.domain/auth/eauthoauth2/callback` as your OAuth `redirect_uri`

5. Enable local logins

6. Enable local username and password login based accounts. WARNING: if disabled, you may be unable to log in if you have not previously configured at least one alternate login method.

7. Enable local logins via email

8. Allow users to request a one-click login link to be sent to them via email.

9. Enable signup cta

10. Show a notice to returning anonymous users prompting them to sign up for an account.

11. Finally, enjoy!

## Notes

For issues and requests: https://github.com/pelith/discourse-eauth
