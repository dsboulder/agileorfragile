class CreateAdminUser < ActiveRecord::Migration
  class Admin < ActiveRecord::Base
    attr_accessible :email, :encrypted_password
  end

  def up
    Admin.create!(:email => 'admin@example.com',
                  :encrypted_password => '$2a$10$uNZ7aIhXp7eIUH31ngbJG.J0kWii9Ojzqx8SPaLKt3jWEFMOfFUxK')  # password
  end

  def down
    Admin.find_by_email("admin@example.com").destroy
  end
end
