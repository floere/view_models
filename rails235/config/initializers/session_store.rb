# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_rails235_session',
  :secret      => '0e591c7f1115ac43793266b099c85ea066b38985d61ee89b5ce6906b6c18e172947110fa16b7edc606b790f77e8c3c7b689a150922174820b18c430a5fc9a736'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
