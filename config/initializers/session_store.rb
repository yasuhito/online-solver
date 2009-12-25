# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_online-solver_session',
  :secret      => 'b1321c4fe8edb98bf68dd828fab1e820bda0a820426f1d55d052da074279561d84f4707dded1c2f99c730b578f6fb5c2efb0c751e6053f96d8d22144e84d4b3b'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
