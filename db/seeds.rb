def scrape_zoopla(location)
  endpoint = 'https://www.zoopla.co.uk/for-sale/property/london/'
  url = endpoint + location
  html_file = open(url).read
  html_doc = Nokogiri::HTML(html_file)

  html_doc.search('.listing-results-wrapper').each do |element|
    name = element.search('.listing-results-attr a').text
    address = element.search('.listing-results-address').text
    photo = element.search('.photo-hover img').attr('src').value
    description = element.search('.listing-results-attr + p').text
    price = element.search('.listing-results-price').text

    property = Property.new(name: name, address: address, price: price, description: description)
    property.remote_photo_url = photo
    property.save
  end

  return nil
end

puts "Cleaning database.."
Property.destroy_all

User.destroy_all
puts "Creating Users.."

users_attributes
User.create!(email: jessica@lewagon.com, password: "1234567"),
User.create!(email: phelim@lewagon.com, password: "1234567"),
User.create!(email: alex@lewagon.com, password: "1234567"),
User.create!(email: donald@lewagon.com, password: "1234567"),
User.create!(email: mcgregor@lewagon.com, password: "1234567"),
User.create!(email: musk@lewagon.com, password: "1234567"),
User.create!(email: amine@lewagon.com, password: "1234567")

# puts "Creating Static Properties"
# properties_attributes = [
#   {
#     location:       'Chelsea',
#     address:        '37 Plont Place, SW3 1HD, London',
#     photo:          'https://lid.zoocdn.com/645/430/2720a3cd34acfc1bb5cd974dee61c2201f9a0032.jpg',
#     year:           '2002',
#     price:          '1.1 Million',
#     crime_rating:   '10%'
#   },
#
#   {
#     location:       'Greewich',
#     address:        '56 KingsLand, SE10 0AB, London',
#     photo:          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQRZgZaMEf1lS9Yz8va4ntv87VyMpZ40LB9l3ob5tqzNwq2n1vUkg',
#     year:           '1997',
#     price:          '2.9 Million',
#     crime_rating:   '10%'
#   },
#
#   {
#     location:        'Hampstead',
#     address:         '6 HampHead, SAL0 0AB, London',
#     photo:           'http://www.brillowen.co.uk/wp-content/uploads/IMAGE-3-1200x797.jpg',
#     year:            '1987',
#     price:           '3.5 Million',
#     crime_rating:    '10%'
#   },
#
#   {
#     location:       'ChinaTown',
#     address:        '7 Beijing Road, SW45 0AB, London',
#     photo:          'https://i2-prod.liverpoolecho.co.uk/incoming/article14378418.ece/ALTERNATES/s615b/JS104068031.jpg',
#     year:           '2005',
#     price:          '1.5 Million',
#     crime_rating:   '10%'
#   },
#
#   {
#     location:        'Victoria',
#     address:         '19 Victoria Road, SO95 0AB, London',
#     photo:           'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQnTu9MNCzONB0jJbRxb1yKG0GQTYW7qn6avRKWURO2lO_nyPba',
#     year:            '2010',
#     price:           '7.8 Million',
#     crime_rating:    '10%'
#   },
#
#   {
#     location:       'Embankment',
#     address:        '22 John Road, LK90W 0AB, London',
#     photo:          'https://lid.zoocdn.com/645/430/299bffcebd3f3bbbc96276ad1f1568d9d49131b4.jpg',
#     year:           '2013',
#     price:          '10 Million',
#     crime_rating:   '10%'
#
#   },
#
#   {
#     location:       'Monument House',
#     address:        '1 Monument Road, SWH7 0AB, London',
#     photo:          'https://media.onthemarket.com/properties/2907250/471666171/image-0-1024x1024.jpg',
#     year:           '2007',
#     price:          '5.3 Million',
#     crime_rating:   '10%'
#   },
#
#
#   {
#     location:       'Pearson',
#     address:        '138 KingsLand Road, LK90W 0AB, London',
#     photo:          'https://lid.zoocdn.com/645/430/299bffcebd3f3bbbc96276ad1f1568d9d49131b4.jpg',
#     year:           '2013',
#     price:          '10 Million',
#     crime_rating:   '10%'
#   },
#
#   {
#     location:       'Burgingham',
#     address:        'Burgingham Palace, LK90W 0AB, London',
#     photo:          'https://www.royal.uk/sites/default/files/images/feature/buckingham-palace.jpg',
#     year:           '1950',
#     price:          '150 Million',
#     crime_rating:   '10%'
#   },
#
#   {
#     location:       'Shoreditch',
#     address:        '47 Shore Road, LK90W 0AB, London',
#     photo:          'https://secure.i.telegraph.co.uk/multimedia/archive/01899/escape-london-5_1899860b.jpg',
#     year:           '2013',
#     price:          '10 Million',
#     crime_rating:   '10%'
#   },
# ]
# Property.create!(properties_attributes)

%w(E2 SW5 W2 HG1 CB3 OX2).each do |postcode|
  puts "Scraping results from #{postcode}"
  scrape_zoopla(postcode)
end

puts "Finished"
