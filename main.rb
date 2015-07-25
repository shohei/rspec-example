require 'active_record'
require 'sqlite3'
require 'rspec'

# Initialize 
ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'mydb.sqlite3'
)

# Migration
class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :name
    end
  end

  def self.down
    drop_table :users
  end
end

class CreateCompanies < ActiveRecord::Migration
  def self.up
    create_table :companies do |t|
      t.string :name
    end
  end

  def self.down
    drop_table :companies
  end
end

# Model definition
class User < ActiveRecord::Base
  belongs_to :company
end

class Company < ActiveRecord::Base
  has_many :users
end

# Setup DB 
begin
  unless User.exists?
    User.create(name: 'nagai')
    User.create(name: 'kie')
  end
rescue
    CreateUsers.migrate(:up)
    User.create(name: 'nagai')
    User.create(name: 'kie')
end

begin
  unless Company.exists?
    Company.create(name: 'afriinc')
  end
rescue
    CreateCompanies.migrate(:up)
    Company.create(name: 'afriinc')
end

# Main program

p User.all
p Company.all

describe Company, :type => :model do
  describe "Relation" do
    it "has many users" do
     expect(Company.users).to match_array users 
    end
  end
end

# describe Company do 
#   it "should aaaaa" do
#     puts "hogesagasdfa"
#   end
# end




