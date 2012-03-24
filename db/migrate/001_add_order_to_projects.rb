class AddOrderToProjects < ActiveRecord::Migration
  def self.up
    add_column :projects, :ord, :integer,
               :null => false, :default => 100
  end

  def self.down
    remove_column :projects, :ord
  end
end
