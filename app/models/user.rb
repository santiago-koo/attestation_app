# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  jti                    :string           not null
#
class User < ApplicationRecord
  has_secure_password

  has_many :user_challenges, dependent: :destroy
  has_many :oauth_access_tokens, class_name: String(Doorkeeper::AccessToken),
                                 foreign_key: :resource_owner_id,
                                 dependent: :delete_all

  def generate_tokens!
    token_values(Doorkeeper::AccessToken.find_or_create_for(
                   application: nil,
                   resource_owner: id,
                   scopes: Doorkeeper.config.default_scopes,
                   expires_in: Doorkeeper.config.access_token_expires_in,
                   use_refresh_token: Doorkeeper.config.refresh_token_enabled?
                 ))
  end

  def revoke_tokens!
    oauth_access_tokens.where(application_id: nil).delete_all
  end

  def token_values(doorkeeper_tokens)
    {
      token: doorkeeper_tokens.token,
      refresh_token: doorkeeper_tokens.refresh_token,
      expires_in: doorkeeper_tokens.expires_in_seconds,
      created_at: doorkeeper_tokens.created_at.to_i
    }.with_indifferent_access
  end
end
