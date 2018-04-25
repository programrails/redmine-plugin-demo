# class CreateContacts
class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :ctype
      t.string :full_name
      t.string :company_website
      t.string :company_tax_id
      t.string :person_phone
      t.references :contactable, polymorphic: true, index: true

      t.column :created_on, :datetime, null: false
      t.column :updated_on, :datetime, null: false
    end
  end
end
