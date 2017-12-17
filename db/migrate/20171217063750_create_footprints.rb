class CreateFootprints < ActiveRecord::Migration[5.1]
  def change
    create_table :footprints do |t|
      t.string :before, limit: 1000
      t.string :after, limit: 1000
      t.string :action
      t.references :trackable, polymorphic: true
      t.references :actor, polymorphic: true

      t.timestamps
    end
  end
end
