class Space < ActiveRecord::Base
  include AlgoliaSearch

  belongs_to :user
  validates :user_id, presence: true
  after_initialize :init
  scope :is_private, -> { where(is_private: true) }
  after_create :ensure_metric_space_ids
  before_save :ensure_appropriate_access

  algoliasearch per_environment: true, disable_indexing: Rails.env.test? do
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

  def named_metrics
      metrics.select{|m| m.keys.length > 0}
  end

  def user_info
    user ? user.as_json : {}
  end

  def init
    self.is_private ||= false
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

  def ensure_appropriate_access
    return !is_private || (user.has_private_access? && !user.satisfied_private_model_count)
  end
end
