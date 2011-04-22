class SearchController < ApplicationController
  
  layout 'application'
  
  def index
    @page = (params[:page] || 1).to_i
    @claim_mains = []
    
    fields = []
    @search_keywords = ''
    
    escape_params = ["utf8", "search_type", "commit", "controller", "action", "search", "page"]
    
    if params[:search_type] == "advance"
      params.each do |k, v|
        if v.to_s != '' && escape_params.rindex(k).nil?
          fields << k.to_sym 
          @search_keywords << v + ' '
        end
      end
    end
    
    if params[:commit]
      search = ClaimMain.solr_search do |s|
        s.keywords(@search_keywords, {:fields => fields}) if params[:search_type] == "advance"
        s.keywords(params[:search]) if params[:search_type] == "normal" && !params[:search].blank?
        s.paginate :per_page => 10, :page => @page       
      end
      @claim_mains = search.results
    end       
  end  
  
  def advance_search
    
  end
end
