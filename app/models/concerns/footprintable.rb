# rails g model footprint before:string{1000} after:string{1000} action:string trackable:references{polymorphic} actor:references{polymorphic}
# usage
# include Footprintable
# has_footprint
module Footprintable
  def self.included(klass)
    klass.class_eval do
      has_many :footprints, as: :trackable
      # :on => after_commit actions[默认 :create, :update],
      # :except => 不需要记录的字段[默认排除:updated_at, :created_at],
      # :extract => 只需要记录的字段[默认所有]
      # except，extract的关系: changed_columns & extract - except
      class_attribute :footprint_options
      # class methods
      class << self
        def has_footprint options = {}
          options[:on]   ||= [:create, :update]
          options[:extract] ||= []
          options[:except] ||= [:updated_at, :created_at]
          self.footprint_options = options
          setup_callbacks_from_options(options[:on])
        end
        def setup_callbacks_from_options options_on = []
          options_on.each do |action|
            # send "after_#{option}", :create_footprint
            after_commit ->(obj) { obj.create_footprint action }, on: action
          end
        end
      end
      # instance methods
      def create_footprint action, opt = {}
        attrs_changed = previous_changes
        return if attrs_changed.empty?
        attrs_changed = attrs_changed.extract! *self.class.footprint_options[:extract] if self.class.footprint_options[:extract].present?
        attrs_changed = attrs_changed.except *self.class.footprint_options[:except] if self.class.footprint_options[:except].present?

        attrs_before  = {}
        attrs_after = {}

        attrs_changed.each do |k, v|
          attrs_before.store(k, v.first) unless v.first.nil?
          attrs_after.store(k, v.last)  unless v.last.nil?
        end
        self.footprints << Footprint.new(before: attrs_before, after: attrs_after, action: action, actor: opt[:actor] || Current.actor)
      end
    end
  end
end