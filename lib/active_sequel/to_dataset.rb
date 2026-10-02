module ActiveSequel
  module ModelToDataset
    # Model => dataset on its table
    def to_dataset
      ActiveSequel.db[table_name.to_sym]
    end
  end

  module RelationToDataset
    # Relation => chainable dataset selecting from the relation's SQL as a subquery
    def to_dataset
      ActiveSequel.db.from(Sequel.as(Sequel.lit("(#{to_sql})"), klass.table_name.to_sym))
    end
  end
end

ActiveRecord::Base.extend(ActiveSequel::ModelToDataset)
ActiveRecord::Relation.include(ActiveSequel::RelationToDataset)
