class CreateTrainData < ActiveRecord::Migration[5.0]
  def change
    # $B2hA|$N%Q%9$O(BID$B$KBP1~$9$k(B
    create_table :train_data do |t|
      t.string :jan          # JAN$B%3!<%I(B
      t.string :label        # $B%i%Y%k(B
      t.timestamps
    end
  end
end
