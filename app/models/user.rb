class User < ActiveRecord::Base
  # Email addresses are not case sensitive, but because some databases are
  # case sensitive, and would consider example@sample.com and
  # EXAMPE@SAMPLE.COM to be two different emails, when the email attribute has
  # a unique index, it is always just best to make sure email addresses are
  # downcased before persisting them. Don't forget to add a unique index to
  # the email attribute in the users table.
  before_save { email.downcase! }

  # This rails method adds password and password confirmation functionality
  # to the app. By adding it to the model together with a password_digest
  # column in the database, Rails will take a new user password and save its
  # digest. Later we can use the authenticate method when logging in users.
  # This method also require the gem bcrypt to be installed for running the
  # algorithm that creates the password hash.
  has_secure_password

  validates :name, presence: true, length: { in: 2..40 }
  # Use a regular expression for checking the format of the email address
  # provided by the user. Also check for uniquess in a non-case_sensitive
  # manner. Keep in mind that email addresses will be downcased before save.
  validates :email, presence: true,
                    length: { maximum: 255 },
                    format: {
                      with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i,
                      message: "incorrect email format"
                    },
                    uniqueness: { case_sensitive: false }

  validates :password, presence: true,
                       length: { minimum: 8 },
                       format: { with: /(?=.*[a-z])(?=.*[A-Z]).+/,
                                 message: "passwords must contain at least one
                                           uppercase letter and one lowercase
                                           letter"}
end
