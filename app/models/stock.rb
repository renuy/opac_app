class Stock < ActiveRecord::Base
  set_table_name 'stock'
  has_many :ibt_stock_positions,
  :finder_sql => 'SELECT p.* FROM ibt_stock_positions p ' +
  'WHERE p.branch_id=#{branch_id} '+ 
  'AND p.title_id = #{title_id} '
  
  def to_jit()
	assigned_cnt = (ibt_stock_positions.nil? or (ibt_stock_positions.size == 0))  ? 0 : ibt_stock_positions[0].assigned_cnt
	fulfilled_cnt = (ibt_stock_positions.nil? or (ibt_stock_positions.size == 0))  ? 0 : ibt_stock_positions[0].fulfilled_cnt
  instore_cnt = in_store_cnt - ( other_branch_in_store_cnt == 0 ? assigned_cnt : 0 )
  other_branch_cnt = other_branch_in_store_cnt - assigned_cnt 
	if assigned_cnt > 0 
  end
    {
      'label' => branch_id,
      'values' => [in_circulation_cnt, instore_cnt , unavailable_cnt, assigned_cnt, other_branch_cnt ]
    }
  end
end