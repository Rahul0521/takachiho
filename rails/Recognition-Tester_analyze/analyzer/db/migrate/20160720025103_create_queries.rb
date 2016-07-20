class CreateQueries < ActiveRecord::Migration[5.0]
  def change
    create_table :queries do |t|
      t.string  :fd_algorithm          # $BFCD'E@8!=P%"%k%4%j%:%`(B
      t.string  :de_algorithm          # $BFCD'NL5-=R%"%k%4%j%:%`(B
      t.string  :option_name           # $B%"%k%4%j%:%`%*%W%7%g%sL>(B
      t.string  :version               # $B%7%9%F%`%P!<%8%g%sHV9f(B($B=i4|CM$O(B0.0.0 $B71N}%G!<%?$N:9$7BX$(Ey$,$"$C$?>l9g$b99?7$9$k(B)
      t.string  :query_image_path      # $B<ALd2hA|$N%U%!%$%k%Q%9(B
      t.integer :query_keypoints_count # $B<ALd2hA|$+$i8!=P$5$l$?FCD'E@$N?t(B
      t.time    :query_datetime        # $B8!=P=hM}<B9T;~9o(B
      t.timestamps
    end
  end
end
