# frozen_string_literal: true

class AddSpecificProfessionToGeneralInfos < ActiveRecord::Migration[5.0]
  def change
    add_column :general_infos, :specific_profile, :json
  end
end
