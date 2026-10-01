# active-sequel

ActiveRecord → Sequel adapter. Sequel reuses ActiveRecord's connection pool
(through `sequel-activerecord_connection`).

```ruby
require "active_sequel" # before defining your models, so scopes get registered

User.to_dataset                       # dataset on the users table
User.where(admin: true).to_dataset    # dataset running the relation's SQL

scopes = ActiveSequel.get_scopes(User) # cached module, one method per AR scope
scopes.older_than(User.to_dataset, 30, 2) # (dataset, *scope_args) => dataset
```

Limit: datasets built from a relation are raw-SQL datasets, so Sequel methods that
rewrite the query (`select`, `where`...) don't apply to them; use scopes instead.

Run the specs with `bundle exec rspec`.
