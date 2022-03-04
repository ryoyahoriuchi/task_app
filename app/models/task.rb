class Task < ApplicationRecord
  validates :name, presence: true, length: { maximum: 50 }
  validates :explanation, presence: true

  enum progress:{
    "未着手": "未着手",
    "着手中": "着手中",
    "完了": "完了",
  }

  enum priority:{
    "低": 0,
    "中": 1,
    "高": 2
  }

  scope :deadline_sorted, -> { order(deadline: :desc)}
  scope :update_sorted, -> { order(updated_at: :desc)}
  scope :progress_search, -> (search){where(progress: "#{search}")}
  scope :name_search, -> (search){ where("name LIKE ?", "%#{search}%") }
  scope :priority_sorted, -> { order(priority: :desc)}
  scope :user_sorted, -> (user){ where(user_id: user)}
  
  scope :with_labels, -> { joins(:labels) }
  scope :search_with_id, -> (labels){ where(labels: {id: labels}) }

  belongs_to :user
  has_many :labelings, dependent: :destroy
  has_many :labels, through: :labelings
end