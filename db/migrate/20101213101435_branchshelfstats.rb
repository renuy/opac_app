class Branchshelfstats < ActiveRecord::Migration
  def self.up
    create_table :branchshelfstats do |t|
      t.integer :branch_id
      t.integer :title_id

      t.integer :warehousetype
      t.integer :available
      t.integer :delivered
      t.integer :error
      t.integer :weeded
      t.integer :damaged
      t.integer :unknown
      t.integer :lost
      t.integer :dispatched
      t.integer :cataloged
      t.integer :received
      t.integer :assigned
      t.integer :ibtassigned
      t.integer :ibtfulfilled
      t.integer :ibtreceived
    end
  end

  def self.down
    drop_table :branchshelfstats
  end
end

# insert into branchshelfstats 
# (
#  branch_id,
#  title_id,
#  warehousetype,
#  available,
#  delivered,
#  error,
#  weeded,
#  damaged,
#  unknown,
#  lost,
#  dispatched,
#  cataloged,
#  received,
#  ibtassigned,
#  ibtfulfilled,
#  ibtreceived)
#select
#  location, 
#  titleid,
#  count(if(status = 'H',1,NULL)),
#  count(if(status = 'A',1,NULL)),
#  count(if(status = 'D',1,NULL)),
#  count(if(status = 'E',1,NULL)),
#  count(if(status = 'W',1,NULL)),
#  count(if(status = 'X',1,NULL)),
#  count(if(status = 'U',1,NULL)),
#  count(if(status = 'L',1,NULL)),
#  count(if(status = 'P',1,NULL)),
#  count(if(status = 'C',1,NULL)),
#  count(if(status = 'R',1,NULL)),
#  count(if(status = 'TS',1,NULL)),
#  count(if(status = 'TF',1,NULL)),
#  count(if(status = 'TR',1,NULL))
#  from jblib.books group by location,titleid;