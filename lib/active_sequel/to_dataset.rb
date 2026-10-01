module ActiveSequel
  module ModelToDataset
    # Model => dataset on its table
    def to_dataset
      ActiveSequel.db[table_name.to_sym]
    end
  end

  module RelationToDataset
    # Relation => dataset running the relation's SQL
    def to_dataset
      ActiveSequel.db.fetch(to_sql)
    end
  end
end

ActiveRecord::Base.extend(ActiveSequel::ModelToDataset)
ActiveRecord::Relation.include(ActiveSequel::RelationToDataset)
