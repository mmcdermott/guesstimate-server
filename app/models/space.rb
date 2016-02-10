class Space < ActiveRecord::Base
  include AlgoliaSearch

  belongs_to :user
  validates :user_id, presence: true
  validate :can_create_private_models
  after_initialize :init
  scope :is_private, -> { where(is_private: true) }
  scope :visible_by, -> (user) { where 'is_private IS false OR user_id = ?', user.try(:id) }
  after_create :ensure_metric_space_ids

  def init
    self.is_private ||= false
  end

  algoliasearch if: :is_public?, per_environment: true, disable_indexing: Rails.env.test? do
    attribute :id, :name, :description, :user_id, :created_at, :updated_at, :is_private
    add_attribute :user_info

    attribute :updated_at_i do
      updated_at.to_i
    end

    attribute :created_at_i do
      created_at.to_i
    end

    attribute :metric_count do
      metrics.length.to_i
    end
  end

  def metrics
    if graph and graph['metrics'].kind_of?(Array)
      graph['metrics'].map{|m| m.slice('name')}
    else
      []
    end
  end

  def is_public?
    !self.is_private
  end

  def user_info
    user ? user.as_json : {}
  end

  def ensure_metric_space_ids
    if graph
      graph['metrics'].each do |metric|
        if !metric.has_key?('space')
          metric['space'] = self.id
        end
      end
      self.save
    end
  end

  def can_create_private_models
    if is_private && !user.try(:can_create_private_models)
      errors.add(:user_id, 'can not make more private models with current plan')
    end
  end
end
