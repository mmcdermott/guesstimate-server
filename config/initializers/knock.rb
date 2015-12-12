Knock.setup do |config|

  config.current_user_from_token = -> (claims) {puts "Authenticating with claims info #{claims}"; User.where(auth0_id: claims['sub']).first }

  ## User handle attribute
  ## ---------------------
  ##
  ## The attribute used to uniquely identify a user.
  ##
  ## Default:
  # config.handle_attr = :email

  ## Current user retrieval from handle when signing in
  ## --------------------------------------------------
  ##
  ## This is where you can configure how to retrieve the current user when
  ## signing in.
  ##
  ## Knock uses the `handle_attr` variable to retrieve the handle from the
  ## AuthTokenController parameters. It also uses the same variable to enforce
  ## permitted values in the controller.
  ##
  ## Default:
  # self.current_user_from_handle = -> (handle) { User.find_by! Knock.handle_attr => handle }

  ## Current user retrieval when validating token
  ## --------------------------------------------
  ##
  ## This is how you can tell Knock how to retrieve the current_user.
  ## By default, it assumes you have a model called `User` and that
  ## the user_id is stored in the 'sub' claim.
  ##
  ## Default:
  # config.current_user_from_token = -> (claims) { User.find claims['sub'] }


  ## Expiration claim
  ## ----------------
  ##
  ## How long before a token is expired.
  ##
  ## Default:
  # config.token_lifetime = 1.day


  ## Audience claim
  ## --------------
  ##
  ## Configure the audience claim to indentify the recipients that the token
  ## is intended for.
  ##
  ## Default:
  # config.token_audience = nil
  config.token_audience = -> { Rails.application.secrets.auth0_client_id }


  ## If using Auth0, uncomment the line below
  # config.token_audience = -> { Rails.application.secrets.auth0_client_id }


  ## Signature key
  ## -------------
  ##
  ## Configure the key used to sign tokens.
  ##
  ## Default:
   #config.token_secret_signature_key = -> { Rails.application.secrets.secret_key_base }
   config.token_secret_signature_key = -> { JWT.base64url_decode Rails.application.secrets.auth0_client_secret }

  ## If using Auth0, uncomment the line below
  # config.token_secret_signature_key = -> { JWT.base64url_decode Rails.application.secrets.auth0_client_secret }

end