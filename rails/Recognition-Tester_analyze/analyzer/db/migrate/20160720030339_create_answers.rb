class CreateAnswers < ActiveRecord::Migration[5.0]
  def change
    create_table :answers do |t|
      t.integer :query_id        # $BG'<1=hM}(B(Query)$B$N(BID
      t.integer :train_datum_id  # $B71N}%G!<%?$N(BID
      t.integer :score           # $BG'<17k2L$N%9%3%"(B
      t.float   :similarytyRatio # $BFCD'E@0lCWN(!J%9%3%"(B / $B<ALd2hA|$NFCD'E@$N?t!K(B
      t.timestamps
    end
  end
end
