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
  
  def IBTRstatChartData(ibtr_stats)
    #params = {:Created => 'All'}
    #ibtr_stats = Ibtr.get_ibtr_stats(params)
  
    statArray = []
  
    ibtr_stats.each do |ibtrStat|
      statArray << Ibtr.to_jit(ibtrStat)
    end
    {
      'label' => ['New', 'Assigned', 'Fulfilled', 'Dispatched','Received','Declined','Cancelled','Duplicate'],
      'values' => statArray
    }
  end

  def IBTRrespChartData(ibtr_stats)
    #params = {:Created => 'All'}
    #ibtr_stats = Ibtr.get_ibtr_stats(params)
  
    statArray = []
  
    ibtr_stats.each do |ibtrStat|
      statArray << Ibtr.resp_to_jit(ibtrStat)
    end
  
    {
      'label' => ['Assigned', 'Fulfilled', 'Declined', 'Dispatched'],
      'values' => statArray
    }
  end

end
