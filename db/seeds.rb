#encoding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

EntityType.create(name:'person')
EntityType.create(name:'company')
EntityType.create(name:'offshore')
EntityType.create(name:'government entity')
EntityType.create(name:'сутність')

RelationshipType.create(name:'owns')
RelationshipType.create(name:'belongs_to')
RelationshipType.create(name:'related_to')
RelationshipType.create(name:'controls')
RelationshipType.create(name: "пов'язані")

