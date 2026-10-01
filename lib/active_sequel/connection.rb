module ActiveSequel
  ADAPTERS = {
    "sqlite3" => :sqlite,
    "postgresql" => :postgres,
    "postgis" => :postgres,
    "mysql2" => :mysql2,
    "trilogy" => :trilogy
  }.freeze

  # A Sequel::Database that borrows connections from ActiveRecord's pool
  # (via sequel-activerecord_connection) instead of opening its own.
  def self.db
    @db ||= begin
      ar_adapter = ActiveRecord::Base.connection_db_config.adapter
      adapter = ADAPTERS.fetch(ar_adapter) { raise ArgumentError, "unsupported ActiveRecord adapter: #{ar_adapter}" }
      Sequel.public_send(adapter, extensions: :activerecord_connection)
    end
  end
end
