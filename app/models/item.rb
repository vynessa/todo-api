class Item < ApplicationRecord
  # Model association
  belongs_to :todo

  # Validations
  validates_presence_of :name
end
