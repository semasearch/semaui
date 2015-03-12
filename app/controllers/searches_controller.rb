#encoding: utf-8
include SearchHelper
include Graphstorage

class SearchesController < ApplicationController

  def root
    @suggest_relationship = SuggestRelationship.new
    render layout: false
  end

  def index
    @searches = Search.all
    neo = Neography::Rest.new
    #MATCH (a)-[:`пов'язані`]->(b) RETURN a,b
    a = "пов'язані"
    str = "MATCH (a)-[:`пов'язані`]->(b) RETURN a,b"
    @test = neo.execute_query(str)['data'].to_json
    respond_to do |format|
      format.json {render json: @test}
      format.html
    end
  end

  def search
    #binding.pry
    @suggest_relationship = SuggestRelationship.new
  	if params[:search] 
      save_search(params[:search])
      entity_names = params[:search].split(",")
    
      if entity_names.size == 0 
        # we have empty string
        @entities = EntityInstance.all
        @resulting_string = search_from_graph_for_all
  	  	

      #elsif entity_names.size = 1

      else 
	  	#split in two
		
    		# search for first entity
    		@entity1 = EntityInstance.search_for_graph(entity_names[0])
  
        #search second entity	
    		@entity2 = EntityInstance.search_for_graph(entity_names[1])

        # if at least one entity is nil we can't search
        if @entity1.nil? || @entity2.nil?  
          @resulting_string = ""
        else 
        	@neo = Neography::Rest.new

      		a = @neo.execute_query("START source=node({node1_id}), target=node({node2_id})
      	 		MATCH p = allShortestPaths(source-[*]-target)
      	 		return nodes(p)", {:node1_id => @entity1.node_id.to_i, :node2_id => @entity2.node_id.to_i})#["data"] #{node1_id}

      		s = ""
      		previous_entity = Hash.new
          entity = Hash.new
      		  a["data"][0][0].each {|x|
      		  	entity[:name] = replace_quotes x["data"]["name"]
              entity[:id] = x["data"]["entity_id"]
      		  	if previous_entity.empty? 
                previous_entity = entity.clone
      		  	else 
                s = s + %Q[{source: {name: "#{previous_entity[:name]}", entity_id: "#{previous_entity[:id]}"}, target: {name: "#{entity[:name]}", entity_id: "#{entity[:id]}"}, type: "Related"},]
      		  	  previous_entity = entity.clone

      		  	end
      		  }
  	  	  
  	  	  @resulting_string = s.chomp(',')
        end

  	  end	
	 
      #puts "results -> " + @resulting_string
  	end

  end

  def search_history
    @searches = Search.all
  end

  def load_info
    @entity_instance = EntityInstance.find(params[:id])
    info = @entity_instance.parse_info
    #binding.pry
    respond_to do |format|
      format.json {render json: info}
    end
  end

  private 
    def save_search(search_for)
      Search.create(search_for: search_for, user_id: current_user.try(:id))
    end

end
#previous_entity = Hash.new
#entity = Hash.new
#  a["data"][0][0].each {|x| 
#    entity[:name] = x["data"]["name"]
#    entity[:id] = x["data"]["entity_id"]
#
#    if previous_entity.any? 
#      previous_entity = entity
#    else 
#      s = s + %Q[{source: {name: "#{previous_entity[:name]}", entity_id: "#{previous_entity[:id]}"}, target: {name: "#{entity[:name]}", entity_id: "#{entity[:id]}"}, type: "Related"},]
#      previous_entity = entity
#    end
#  }