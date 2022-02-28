class Task < ApplicationRecord
  validates :name, presence: true, length: { maximum: 50 }
  validates :explanation, presence: true

  enum progress:{
    "未着手": "未着手",
    "着手中": "着手中",
    "完了": "完了",
  }

  scope :deadline_sorted, -> { order(deadline: :desc)}
  scope :update_sorted, -> { order(updated_at: :desc)}
  scope :progress_search, -> (search){where(progress: "#{search}")}
  scope :name_search, -> (search){ where("name LIKE ?", "%#{search}%") }
end