# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


x = PropertyType.create!(:name => "color")
y = PropertyType.create!(:name => "capacity")
z = PropertyType.create!(:name => "pattern")

a = Property.create!(:name => "blue", :status => 2, :property_type_id => x.id)
b = Property.create!(:name => "green", :status => 2, :property_type_id => x.id)
c = Property.create!(:name => "black", :status => 2, :property_type_id => x.id)
d = Property.create!(:name => "yellow", :status => 2, :property_type_id => x.id)
e = Property.create!(:name => "100 watts", :status => 2, :property_type_id => y.id)
f = Property.create!(:name => "2000 mhz", :status => 2, :property_type_id => y.id)
g = Property.create!(:name => "45000 mhz", :status => 2, :property_type_id => y.id)
h = Property.create!(:name => "Checkered", :status => 2, :property_type_id => z.id)
i = Property.create!(:name => "Graphic print", :status => 2, :property_type_id => z.id)
j = Property.create!(:name => "Applique", :status => 2, :property_type_id => z.id)

SizeList.create!(:name => "NONE", :status => 2)
SizeList.create!(:name => "SMALL", :status => 2)
SizeList.create!(:name => "REGULAR", :status => 2)
SizeList.create!(:name => "MEDIUM", :status => 2)
SizeList.create!(:name => "LARGE", :status => 2)
SizeList.create!(:name => "LOW", :status => 2)
SizeList.create!(:name => "TWELVE", :status => 2)

Brand.create!(:name => "APPLE", :status => 2)
Brand.create!(:name => "PEPSI", :status => 2)
Brand.create!(:name => "SAMSUNG", :status => 2)
Brand.create!(:name => "AMZER", :status => 2)
Brand.create!(:name => "REEBOK", :status => 2)
Brand.create!(:name => "NIKE", :status => 2)

men = Category.create!(:name => "MEN", :status => 2, :parent_category_id => nil)
women = Category.create!(:name => "MEN", :status => 2, :parent_category_id => nil)
men_watches = Category.create!(:name => "WATCHES", :status => 2, :parent_category_id => men.id)
men_clothing = Category.create!(:name => "CLOTHING", :status => 2, :parent_category_id => men.id)
women_watches = Category.create!(:name => "WATCHES", :status => 2, :parent_category_id => women.id)
women_clothing = Category.create!(:name => "CLOTHING", :status => 2, :parent_category_id => women.id)
men_winter = Category.create!(:name => "WINTER WEAR", :status => 2, :parent_category_id => men_clothing.id)
women_summer = Category.create!(:name => "SUMMER WEAR", :status => 2, :parent_category_id => women_clothing.id)
men_jac = Category.create!(:name => "JACKETS", :status => 2, :parent_category_id => men_winter.id)
women_jeans = Category.create!(:name => "JEANS", :status => 2, :parent_category_id => women_summer.id)
men_analog = Category.create!(:name => "ANALOG", :status => 2, :parent_category_id => men_watches.id)
women_digital = Category.create!(:name => "DIGITAL", :status => 2, :parent_category_id => women_watches.id)
electronics = Category.create!(:name => "ELECTRONICS", :status => 2, :parent_category_id => nil)
power_bank = Category.create!(:name => "POWER BANKS", :status => 2, :parent_category_id => electronics.id)



User.create!(name: "sam", email: "sss_123443@yahoo.com", password: "foobar", password_confirmation: "foobar", is_admin: false)
User.create!(name: "saurabh", email: "saurabhsg83@gmail.com",password: "saurabh", password_confirmation: "saurabh", is_admin: true)





