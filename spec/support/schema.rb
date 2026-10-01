ActiveRecord::Schema.verbose = false
ActiveRecord::Schema.define do
  create_table :users do |t|
    t.string :name
    t.integer :age
    t.boolean :admin, default: false
  end

  create_table :posts do |t|
    t.references :user
    t.string :title
    t.boolean :published, default: false
  end

  create_table :comments do |t|
    t.references :post
    t.string :body
  end
end
