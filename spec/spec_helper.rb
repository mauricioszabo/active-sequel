require "active_record"
require "active_sequel"

ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")

require_relative "support/schema"
# Models must be loaded after active_sequel so their scopes get registered.
require_relative "support/models"

RSpec.configure do |config|
  config.around do |example|
    ActiveRecord::Base.transaction do
      example.run
      raise ActiveRecord::Rollback
    end
  end
end
