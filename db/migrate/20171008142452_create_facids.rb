class CreateFacids < ActiveRecord::Migration[5.0]
  def change
    create_table :facids do |t|
      t.integer :colid
      t.string :name

      t.timestamps
    end
  end
end
