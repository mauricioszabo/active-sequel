module ActiveSequel
  # ActiveRecord doesn't keep scope bodies around, so we record the arity of
  # each scope as it is declared. Load active_sequel before defining models.
  module ScopeRegistry
    @scopes = {}

    class << self
      def register(model, name, arity)
        (@scopes[model] ||= {})[name.to_sym] = arity
      end

      # name => arity, including scopes inherited from parent models
      def for(model)
        model.ancestors.reverse.each_with_object({}) do |klass, all|
          all.merge!(@scopes[klass] || {})
        end
      end
    end

    module Recorder
      def scope(name, body, &block)
        ScopeRegistry.register(self, name, body.respond_to?(:arity) ? body.arity : -1)
        super
      end
    end
  end
end

ActiveRecord::Base.singleton_class.prepend(ActiveSequel::ScopeRegistry::Recorder)
