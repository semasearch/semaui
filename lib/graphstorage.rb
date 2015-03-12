#encoding: utf-8
module Graphstorage 

  DEFAULT_ENTITY_TYPE = EntityType.where(name: 'сутність').first.try(:id)
  DEFAULT_RELATION_TYPE = RelationshipType.where(name: "пов'язані").first.try(:id)

  require 'neo4j-core'

  def create_relationship_in_graph(relationship)
    my_session = Neo4j::Session.create_session(:server_db, "http://localhost:7474")
    node_from = Neo4j::Node.load(relationship.entity_from.node_id) #Neo4j::Node.create
    node_to = Neo4j::Node.load(relationship.entity_to.node_id)
    rel_type = relationship.relationship_type
    node_rel = node_from.create_rel(rel_type.name, node_to)

    #logger.info "rel id " + node_rel.neo_id.to_s
    relationship.rel_node_id = node_rel.neo_id
    relationship.save

          # my_session = Neo4j::Session.create_session(:server_db, "http://localhost:7474")
      # node_from = Neo4j::Node.load(EntityInstance.find_by_id(@relationship.entity_instance_from).node_id) #Neo4j::Node.create
      # node_to = Neo4j::Node.load(EntityInstance.find_by_id(@relationship.entity_instance_to).node_id)
      # rel_type = RelationshipType.find_by_id(@relationship.relationship_type_id)
      # node_rel = node_from.create_rel(rel_type.name, node_to)

      # #logger.info "rel id " + node_rel.neo_id.to_s
      # @relationship.rel_node_id = node_rel.neo_id
      # @relationship.save

      # Alternative
      #Neo4j::Relationship.create(:knows, n1, n2, since: 1994)
  end

  def create_entity_in_graph(entity_instance)
      my_session = Neo4j::Session.create_session(:server_db, "http://localhost:7474")
      #puts "Created node #{node[:name]} with labels #{node.labels.map(&:name).join(', ')}" 
        
      # create a node graph database and relate to one stored in relational
      node = Neo4j::Node.create({name: entity_instance.name, id: entity_instance.id, description: entity_instance.description })
      puts node.inspect
      entity_instance.node_id = node.neo_id
      puts entity_instance.inspect

      # and save again
      entity_instance.save
  end

  def store_from_string(entity_in_string)
    #data_row = "a1|reltype|b1|url".split("|")
    data_row = entity_in_string.split("|")
    node1_name = data_row[0]
    node2_name = data_row[2]
    rel_type = data_row[1]
    url = data_row[3]

    e1 = EntityInstance.search_for_graph(node1_name)
    if e1.nil? 
      e1 = EntityInstance.create(name: node1_name, user_id: current_user.try(:id), entity_type_id: DEFAULT_ENTITY_TYPE)
    end

    e2 = EntityInstance.where(name: node2_name).first
    if e2.nil?
      e2 = EntityInstance.create(name: node2_name, user_id: current_user.try(:id), entity_type_id: DEFAULT_ENTITY_TYPE)
    end

    r = Relationship.where(entity_instance_to: e2.id).where(entity_instance_from: e1.id).first
    if r.nil? 
      r = Relationship.create(entity_instance_to: e2.id, 
                              entity_instance_from: e1.id, 
                              user_id: current_user.try(:id), 
                              relationship_type_id: DEFAULT_RELATION_TYPE)
      r.relationship_bits.create(url: url)
    end
  end

  def search_from_graph_for_all
    @neo = Neography::Rest.new
    #querying for nodes
    cypher_query =  " START node = node(*)"
    cypher_query << " RETURN ID(node), node"
    nn = @neo.execute_query(cypher_query)["data"].collect{|n| {"id" => n[0]}.merge(n[1]["data"])}

    # querying for edges
    cypher_query =  " START source = node(*)"
    cypher_query << " MATCH source -[rel]-> target"
    cypher_query << " RETURN ID(rel), ID(source), ID(target)"
    rr = @neo.execute_query(cypher_query)["data"].collect{|n| 
      {"id" => n[0], 
          "source" => n[1], 
          "target" => n[2]
      } 
    }

    rst = ""
    source = Hash.new
    target = Hash.new
    
    rr.each { |r|
      nn.each { |e| 
        puts "INFO: " + e.to_s
        if e["id"] == r["source"] 
          source[:name] = e["name"]
          source[:id] = e['entity_id']
        end
        if e["id"] == r["target"]
          target[:name] = e["name"]
          target[:id] = e['entity_id']
        end
      }
          
      rst = rst + %Q[{source: {name: "#{URI.escape(source[:name])}", entity_id: "#{source[:id]}"}, target: {name: "#{URI.escape(target[:name])}", entity_id: "#{target[:id]}"}, type: "Related"},]
    }

    rst.chomp(',')
  end
end