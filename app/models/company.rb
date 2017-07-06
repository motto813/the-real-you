class Company < ActiveRecord::Base
  has_many :positions

  validates :name, presence: true, uniqueness: true
end
