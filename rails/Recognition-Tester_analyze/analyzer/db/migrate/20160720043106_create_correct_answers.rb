class CreateCorrectAnswers < ActiveRecord::Migration[5.0]
  def change
    create_table :correct_answers do |t|
      t.integer :query_id       # $B8!=P=hM}(BID
      t.integer :train_datum_id # $B@52r$H$J$k71N}%G!<%?$N(BID
      t.timestamps
    end
  end
end
