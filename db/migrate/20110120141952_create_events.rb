class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string :event_type
      t.string :val1
      t.string :val2
      t.string :val3
      t.string :val4
      t.string :val5
      t.string :val6
      t.string :val7
      t.string :val8
      t.string :val9
      t.string :val10
      t.string :val11
      t.string :val12
      t.string :val13
      t.string :val14
      t.string :val15
      t.string :val16
      t.string :val17
      t.string :val18
      t.string :val19
      t.string :val20
      t.string :val21
      t.string :val22
      t.string :val23
      t.string :val24
      t.string :val25
      t.string :val26
      t.string :val27
      t.string :val28
      t.string :val29
      t.string :val30
      t.string :val31
      t.string :val32
      t.string :val33
      t.string :val34
      t.string :val35
      t.string :val36
      t.string :val37
      t.string :val38
      t.string :val39
      t.string :val40
      t.string :val41
      t.string :val42
      t.string :val43
      t.string :val44
      t.string :val45
      t.string :val46
      t.string :val47
      t.string :val48
      t.string :val49
      t.string :val50
      t.string :val51
      t.string :val52
      t.string :val53
      t.string :val54
      t.string :val55

      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
