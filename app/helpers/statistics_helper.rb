module StatisticsHelper
  def jitBarChart(title_id)
    stock = Stock.find_all_by_title_id(title_id, :order => "branch_id")
  
    stockArray = []
  
    stock.each do |storeStock|
      stockArray << storeStock.to_jit
    end
  
    {
      'label' => ['in circulation', 'in store', 'unavailable', 'assigned'],
      'values' => stockArray
    }
  end
end
