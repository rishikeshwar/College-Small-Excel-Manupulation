class CreateJournals < ActiveRecord::Migration[5.0]
  def change
    create_table :journals do |t|
      t.string :title
      t.string :author
      t.string :status
      t.string :JorC
      t.string :scopus
      t.string :affiliations
      t.integer :amritapapers
      t.string :coauthor
      t.string :communicated
      t.string :paperbefore

      t.timestamps
    end
  end
end
