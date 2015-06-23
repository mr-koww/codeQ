class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :omniauthable, omniauth_providers: [:facebook, :github, :twitter]

  has_many :questions
  has_many :subscribers, dependent: :destroy
  has_many :answers
  has_many :votes
  has_many :authorizations

  def self.find_for_oauth(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization

    if auth.info[:email] =~ Devise.email_regexp
      email = auth.info[:email]
    else
      email = "#{auth.uid.to_s}@#{auth.provider}.com"
    end

    user = User.where(email: email).first
    if user
      user.create_authorization(auth)
    else
      password = Devise.friendly_token[0, 20]
      user = User.new(email: email, password: password, password_confirmation: password)
      user.skip_confirmation!
      user.save!
      user.create_authorization(auth)
    end
    user
  end

  def create_authorization(auth)
    self.authorizations.create(provider: auth.provider, uid: auth.uid.to_s)
  end

  def subscription_to(question)
    subscribers.find { |subscribe| subscribe.question_id == question.id }
  end

  # ActiveJobs
  def self.send_daily_digest
    find_each do |user|
      DailyMailer.delay.digest(user)
    end
  end
end