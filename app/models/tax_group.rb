class TaxGroup < ActiveRecord::Base
	has_and_belongs_to_many :taxes
	validates :name, presence: true

	def to_s
    	name
 	end
end
