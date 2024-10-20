# frozen_string_literal: true

class LoginInfo < ApplicationRecord
  validates_presence_of :email
  validates_presence_of :password
  validates_confirmation_of :password
  validate :password_requirements_are_met # not needed for FB or Google login
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  validates_uniqueness_of :email
  validates :email, presence: true

  attr_accessor :password_confirmation

  def self.search(search_arg)
    if search_arg[:email_regex].nil? || (search_arg[:email_regex] == '')
      return LoginInfo.where('email ILIKE ?', search_arg[:email])
    end

    if search_arg[:email_regex].present? && (search_arg[:email_regex] != '') && search_arg[:email].present? && (search_arg[:email] != '')
      case search_arg[:email_regex]
      when 'Contains'
        search_arg[:email] = "%#{search_arg[:email]}%"
      when 'Starts With'
        search_arg[:email] = "#{search_arg[:email]}%"
      when 'Ends With'
        search_arg[:email] = "%#{search_arg[:email]}"
      when 'Exactly Matches'
        search_arg[:email] = search_arg[:email]
      end
    else
      search_arg[:email] = '%'
    end
    LoginInfo.where('email ILIKE ?', search_arg[:email])
  end

  def password_requirements_are_met
    rules = {
      ' must contain at least one lowercase letter' => /[a-z]+/,
      ' must contain at least one uppercase letter' => /[A-Z]+/,
      ' must contain at least one digit' => /\d+/,
      ' must contain at least one special character' => /[^A-Za-z0-9]+/
    }

    rules.each do |message, regex|
      errors.add(:password, message) unless password.match(regex)
    end
  end

  def validate_pwd
    validate :password_requirements_are_met # not needed for FB or Google sign up
  end
end
