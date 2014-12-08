# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

"republikove-organy;Republikové orgány;100
jihocesky-kraj;Jihočeský kraj;1
jihomoravsky-kraj;Jihomoravský kraj;2
karlovarsky-kraj;Karlovarský kraj;3
kralovehradecky-kraj;Královéhradecký kraj;4
liberecky-kraj;Liberecký kraj;5
moravskoslezsky-kraj;Moravskoslezský kraj;6
olomoucky-kraj;Olomoucký kraj;7
pardubicky-kraj;Pardubický kraj;8
plzensky-kraj;Plzeňský kraj;9
praha;Praha;10
stredocesky-kraj;Středočeský kraj;11
ustecky-kraj;Ústecký kraj;12
kraj-vysocina;Kraj Vysočina;13
zlinsky-kraj;Zlínský kraj;14".split("\n").each{|line|
	slug, name, id = line.split(';')
	Organization.create(id:id, name:name, slug:slug)
}
