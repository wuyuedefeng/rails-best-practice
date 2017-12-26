class CreateRemarks < ActiveRecord::Migration[5.1]
  def change
    create_table :remarks do |t|
      t.string :text
      t.references :trackable, polymorphic: true
      t.references :actor, polymorphic: true

      t.timestamps
    end
  end
end
