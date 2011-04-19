class SearchController < ApplicationController
  
  def index
    @page = (params[:page] || 1).to_i
    @claim_mains = []
    if !params[:search].blank?     
      search = ClaimMain.solr_search do |s|
        s.keywords params[:search]
        s.paginate :per_page => 10, :page => @page       
      end
      
      @claim_mains = search.results
    end
    
  end  
end
