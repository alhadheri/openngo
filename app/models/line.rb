class Line < ActiveRecord::Base
  belongs_to :cost
  
  validates :name, presence: true

  after_save :update_total_cost

  private

    def update_total_cost
      if self.cost.lines.any?
        cost_lines = self.cost.lines.pluck(:price, :quantity)
        self.cost.update_attribute(:total_cost, cost_lines.inject(0) { |sum, line| sum + (line[0]*line[1]) })
      end
    end
end