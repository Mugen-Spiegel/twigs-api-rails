class MonthlyDueTransaction < ApplicationRecord

    include StatusList

    belongs_to :user
    belongs_to :monthly_due
    validates :year, :month, uniqueness: { scope: %i[year month user_id], message: "Transaction Exists" }
    validates :is_paid, :bill_amount, :user_id, :year, :month, :monthly_due_id, presence: true

    enum :month, {January:1, February:2, March:3, April:4, May:5, June:6, July:7, August:8, September:9, October:10, November:11, December:12}

end
