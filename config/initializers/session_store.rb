# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_noticias-do-piaui_session',
  :secret      => 'bf9a89a9f1053bc7c653b841758f757364eee9577af72d1bb37c353371130d7c2a6773f51f2dd2a49b62edffbbb9dc372ea82dcdc576d8de989c94c3732607be'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
