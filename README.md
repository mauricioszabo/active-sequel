# active-sequel

ActiveRecord → Sequel adapter. Sequel reuses ActiveRecord's connection pool
(through `sequel-activerecord_connection`).

```ruby
require "active_sequel" # before defining your models, so scopes get registered

User.to_dataset                       # dataset on the users table
User.where(admin: true).to_dataset    # chainable dataset over the relation's SQL (as a subquery)

scopes = ActiveSequel.get_scopes(User) # cached module, one method per AR scope
scopes.older_than(User.to_dataset, 30, 2) # (dataset, *scope_args) => dataset
```

Run the specs with `bundle exec rspec`.
