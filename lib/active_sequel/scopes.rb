module ActiveSequel
  @scope_modules = {}

  # Returns a (cached) module with one method per scope of +model+. Each method
  # takes a dataset followed by the scope's own arguments, and returns a dataset.
  def self.get_scopes(model)
    @scope_modules[model] ||= build_scopes_module(model)
  end

  def self.apply_scope(model, dataset, name, args)
    relation = model.unscoped.from("(#{dataset.sql}) AS #{model.connection.quote_table_name(model.table_name)}")
    relation.public_send(name, *args).to_dataset
  end
  private_class_method :apply_scope

  def self.build_scopes_module(model)
    mod = Module.new
    ScopeRegistry.for(model).each do |name, arity|
      required = arity >= 0 ? arity : -arity - 1
      params = ["dataset", *Array.new(required) { |i| "arg#{i}" }]
      params << "*rest" if arity < 0
      mod.module_eval <<~RUBY, __FILE__, __LINE__ + 1
        def self.#{name}(#{params.join(", ")})
          ActiveSequel.send(:apply_scope, @model, dataset, :#{name}, [#{params[1..].join(", ")}])
        end
      RUBY
    end
    mod.instance_variable_set(:@model, model)
    mod
  end
  private_class_method :build_scopes_module
end
