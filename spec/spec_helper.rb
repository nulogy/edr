require 'active_record'
require 'database_cleaner'

ActiveRecord::Base.establish_connection(
    adapter: 'sqlite3',
    database: ':memory:',
)

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end