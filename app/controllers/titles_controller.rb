class TitlesController < ApplicationController
  def index
    newSearch = Sunspot.new_search(Title) do
      paginate(:page => params[:page], :per_page => 15)
      facet(:category_id, :publisher_id, :author_id)
    end
    
    if !params[:queryTitleId].blank?
      if Title.exists?(params[:queryTitleId])
        @title = Title.find(params[:queryTitleId])
        if params[:query].blank?
          params[:query] = @title.title
        else
          params[:queryTitleId] = ""
        end
      end
    end
    
#    newSearch = Sunspot.new_search(Title) do
#      keywords params[:query] do
#        highlight :title, :publisher, :author
#      end
#      paginate(:page => params[:page], :per_page => 15)
#      facet(:category_id, :publisher_id, :author_id)
#    end
 
    newSearch.build do
      keywords params[:query] do
        highlight :title, :publisher, :author
      end
    end
    
    newSearch.build do 
      with(:category_id, params[:facetCategory]) 
    end if params[:facetCategory].to_i > 0

    newSearch.build do 
      with(:publisher_id, params[:facetPublisher]) 
    end if params[:facetPublisher].to_i > 0

    newSearch.build do 
      with(:author_id, params[:facetAuthor]) 
    end if params[:facetAuthor].to_i > 0
  
    @searchResults = newSearch.execute
  end
  
  def qryAltTitle
    @searchResults = index
    @ibtrId = params[:ibtrId]
    render 'ibtrs/qryAltTitle' , :layout => 'blank'
  end

# not using more like this- not sure how this is working as of now
  def show
    @title = Title.find(params[:id])

    newSearch = Sunspot.new_more_like_this(@title, Title) do
      paginate(:page => params[:page], :per_page => 15)
      facet(:category_id, :publisher_id, :author_id)
    end
  
    newSearch.build do 
      with(:category_id, params[:facetCategory]) 
    end if params[:facetCategory].to_i > 0

    newSearch.build do 
      with(:publisher_id, params[:facetPublisher]) 
    end if params[:facetPublisher].to_i > 0

    newSearch.build do 
      with(:author_id, params[:facetAuthor]) 
    end if params[:facetAuthor].to_i > 0
  
    @searchResults = newSearch.execute

#    @searchResults = Sunspot.more_like_this(@title, Title) do
#      fields :title, :publisher, :author
#      paginate(:page => params[:page], :per_page => 15)
#      facet(:category_id, :publisher_id, :author_id)
#    end
  end
end
