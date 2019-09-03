# Eauth Authentication Plugin

This plugin adds support for logging in to a Discourse site via Eauth.

## Installation

1. Follow the directions at [Install a Plugin](https://meta.discourse.org/t/install-a-plugin/19157) using https://github.com/pelith/discourse-eauth as the repository URL. (use `git clone https://github.com/pelith/discourse-eauth.git --branch ENS` for `app.yml` if you want to use ENS as username)
2. Rebuild the app using `./launcher rebuild app`
3. In your Discourse instance, go to Site Settings, filter by "Eauth".
4. Check the "eauth enabled" checkbox, and you're done!

## Notes

For issues and requests: https://github.com/pelith/discourse-eauth
