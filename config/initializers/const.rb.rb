module CONST
  # Email
  REGEXP_EMAIL = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i.freeze
  # Phone
  REGEXP_MOBILE = /\A1\d{10}\z/.freeze
end