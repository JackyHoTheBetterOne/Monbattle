class UnlockCode < ActiveRecord::Base
  validates :code, presence: true, uniqueness: true
  validates :category, presence: true

  # SecureRandom.urlsafe_base64(n)[0..n-1]

end
