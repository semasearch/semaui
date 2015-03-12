class AdmintoolsController < ApplicationController
 
  include Graphstorage
  
  def index
  end

  def clear
  	#echo Removing all entities, relationships in database and graph

  	Relationship.delete_all
  	EntityInstance.delete_all

  	graph_query = "MATCH (n) OPTIONAL MATCH (n)-[r]-() DELETE n,r" 
  	neo = Neography::Rest.new
  	neo.execute_query(graph_query)

  	flash[:notice] = 'Successfully cleared the data in graph and database'

  	redirect_to admintools_path
  end


  def addrows
  	puts "Add rows"
  	triplet ="a1|reltype|b1|url"
  	store_from_string(triplet)

  	flash[:notice] = 'Successfully added graph entries'

  	redirect_to admintools_path
  end

  def upload
  	uploaded_io = params[:ntriplet]
  	#puts uploaded_io.read.inspect
    if uploaded_io
      entities_before_upload = EntityInstance.all.length
      relationships_before_upload = Relationship.all.length
      str = uploaded_io.read.force_encoding('utf-8')
      str.each_line do |line|
        store_from_string(line)
      end
      entities_added_after_upload = EntityInstance.all.length - entities_before_upload
      relationships_added_after_upload = Relationship.all.length - relationships_before_upload
      flash[:notice] = "Successfully uploaded #{entities_added_after_upload} entities and #{relationships_added_after_upload} relationships"
      redirect_to admintools_path
    else
      flash[:notice] = 'Choose file to upload'
      redirect_to admintools_path
    end
  end

  def upload_yaml
  	uploaded_io = params[:yaml_file]
  	str = uploaded_io.read.force_encoding('utf-8')
  	
  	o = Container.new
  	o = YAML::load(str)

  	o.entities.each {|e|
  		e.save
  	}


  	flash[:notice] = 'Successfully uploaded graph entries'
  	redirect_to admintools_path
  end


  def download
  	# take all entity instances
  	# for each take relationships
  	# for each relationship build string with url 
  	full_string = ""
  	all_entities = EntityInstance.all 
  
  	all_entities.each { |e| 
  	  all_relationships_to = Relationship.where(entity_instance_to: e.id)
	  all_relationships_to.each { |r|
  	  	#puts e.inspect
  	  	#puts EntityInstance.find(r.entity_instance_from).name
  	  	#puts r.relationship_type.name
  	  	#puts r.relationship_bits.all.first.url
  	  	s = "#{e.name}|#{r.relationship_type.name}|#{EntityInstance.find(r.entity_instance_from).name}|#{r.relationship_bits.all.first.url}"
  	  	full_string = full_string + s
  	  	#puts r.entity_from.inspect
  	  	#puts "#{e.name} +  + #{r.entity_from.name}" 
  	  	##{r.relationship_type.name}
  	  }

  	  all_relationships_from = Relationship.where(entity_instance_from: e.id)
  	} 

  	puts full_string
  	send_data full_string,  :filename => "semasearch.triplet"

  end

  class Container
  	attr_accessor  :entities, :relationships, :relationship_bits

  	def initialize
    	self.entities = []
    	self.relationships = []
    	self.relationship_bits = []
  	end
  end

  def download_full
  	o = Container.new
	puts EntityInstance.all.inspect
	ei = EntityInstance.all
  	ei.each {|i| 
  		puts i.name
  		puts i.inspect
  	o.entities.push(i.to_yaml) } #(EntityInstance.all)
  	o.relationships.push(Relationship.all)
  	o.relationship_bits.push(RelationshipBit.all)
  	
  	send_data Psych.dump(o),  :filename => "semasearch_full_yaml.triplet"
  end
end
