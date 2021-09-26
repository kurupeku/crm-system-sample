# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id           :bigint           not null, primary key
#  company_name :string
#  email        :string           not null
#  name         :string           not null
#  tel          :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class User < ApplicationRecord
  with_options presence: true do
    validates :name
    validates :email, format: { with: EMAIL_REGEXP }
    validates :tel, format: { with: PHONE_NUMBER_REGEX }
  end

  def created_at_unix
    created_at&.to_i
  end

  def updated_at_unix
    updated_at&.to_i
  end
end