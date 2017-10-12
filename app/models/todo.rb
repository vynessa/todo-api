class Todo < ApplicationRecord
    # Model association
    has_many :items, dependent: :destroy

    # Validations
    validates_presence_of :title, :created_by
end
