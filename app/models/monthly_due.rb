class MonthlyDue < ApplicationRecord
    belongs_to :subdivision
    validates :amount, :is_current, :subdivision_id, presence: true
end
