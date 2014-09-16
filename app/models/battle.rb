class Battle < ActiveRecord::Base
  belongs_to :battle_level

  has_many :fights, dependent: :destroy
  has_many :users, through: :fights

  validates :battle_level_id, presence: {message: 'Must be entered'}


  def as_json(options={})
    super(
      :include => {:users =>{
        :include => { :parties => {
          :include => { :monsters => {
            :include => { :monster_equipped_abilities => {
              :include => { :effects => {}}
            }}
          }}
        }}
      }}
    )
  end
end
