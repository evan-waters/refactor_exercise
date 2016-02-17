class Person < ActiveRecord::Base
  before_create :generate_slug, :generate_team_and_handle
  after_create :send_validation_email

  scope :admins, -> { where(admin: true) }
  scope :not_validated, -> { where(validated: false) }
  scope :created_before, ->(time) { where('created_at < ?', time)}

  def send_validation_email
    Emails.validate_email(self).deliver
    Emails.admin_new_user(Person.admins, self).deliver
  end

  def validate_email
    update_attribute(validated: true)
    Rails.logger.info "USER: User ##{id} validated email successfully."
    Emails.admin_user_validated(Person.admins, self)
  end

  def send_welcome_email
    Emails.welcome(self).deliver!
  end

  def generate_slug
    self.slug = "ABC123#{Time.now.to_i.to_s}1239827#{rand(10000)}"
  end

  def generate_team_and_handle
    person_count = Person.count + 1

    if person_count.odd?
      self.team = "UnicornRainbows"
      self.handle = "UnicornRainbows" + person_count.to_s
    else
      self.team = "LaserScorpions"
      self.handle = "LaserScorpions" + person_count.to_s
    end
  end
end