class AddUuidToSubdivision < ActiveRecord::Migration[7.1]
  def change
    add_column :subdivisions, :uuid, :uuid, default: "gen_random_uuid()", null: false
  end
end
