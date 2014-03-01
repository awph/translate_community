class UserTranslationsScore < ActiveRecord::Base
  belongs_to :user
  belongs_to :translation
end
