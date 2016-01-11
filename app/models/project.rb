require 'trello'
class Project < ActiveRecord::Base
	belongs_to :branch
  has_many :project_milestones

  has_many :project_attachments
  
  belongs_to :location
	# has_many :project_locations
  #  has_many :locations, through: :project_locations

	has_many :project_donors
  has_many :donors, through: :project_donors

  
  has_many :project_roles
  has_many :roles, through: :project_roles
  
  has_many :project_partners
  has_many :organizations, through: :project_partners
  
	validates :name, uniqueness: true 
	validates :name, :goal, :budget, presence: true
 	validates :budget, numericality: { allow_blank: true }

  accepts_nested_attributes_for :project_attachments

  translates :name, :description, fallbacks_for_empty_translations: true
  accepts_nested_attributes_for :translations

  after_create :create_trello_board 

  private
    def create_trello_board 
      board_name = self.name
      board_description =  self.description
      board = Trello::Board.all.detect do |board|
        board.name =~ /#{board_name}/
      end
      unless board
        board = Trello::Board.create(
          name: board_name,
          description: board_description
        )
      end  
    end
end