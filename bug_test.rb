require 'active_record'
require 'minitest/autorun'
require 'logger'

# This connection will do for database-independent bug reports.
if ENV["POSTGRESQL"] == "true"
  connection_options = {
    adapter: 'postgresql',
    database: 'bug_test',
    prepared_statements: false
  }
else
  connection_options = {
    adapter: 'sqlite3',
    database: ':memory:',
    prepared_statements: false
  }
end
ActiveRecord::Base.establish_connection(connection_options)
ActiveRecord::Base.logger = Logger.new(STDOUT)

ActiveRecord::Schema.define do
  create_table :posts, force: true do |t|
    t.decimal :test_column
  end
end

class Post < ActiveRecord::Base
end

class BugTest < MiniTest::Test
  def test_21262
    p = Post.create!(test_column: BigDecimal::NAN)
    assert_equal p, Post.where(test_column: BigDecimal::NAN).first
  end
end
