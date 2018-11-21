require 'open-uri'
require 'nokogiri'
require 'json'
require 'csv'

class PropertiesController < ApplicationController
  def new
    @property = Property.new
  end

  def create
    @property = Property.new(property_params)
    if @property.save!
      redirect_to property_path(@property)
    else
      render :new
    end
  end

  def index
    @properties = search_house

    # Had to comment this out:
    # It overwrites the variable holding scraped results and doesn't actually
    # return anything since the DB doesn't have saved instances of Property yet
    # search_house uses .new and doesn't .save --> in memory, never saved to DB

    # @properties = Property.where.not(latitude: nil, longitude: nil)

    @markers = @properties.map do |property|
      {
        lng: property.longitude,
        lat: property.latitude
      }
    end
  end

  def show
    postcodes = ['E26FG','SW50NU','W1A0AA','W1W5AL','W1W5AP','W60AT','W60DE','W60HR','W84BA','W84BH',
              'W84HL','W84QY','N20AA','N20ND','NW10BJ','SE10BD','SE10EY','SE10QB','SW31NU','B11JX',
              'B375AE','B495AA','HG11HQ','HG11PW','L10AA','L250LA','NE311AD','NE697AD','SO206AA','SO531DA',
              'YO322AA','YO624ED','YO624NA','WA95NQ','DT11QQ','DT96SX','CH339BZ','CH630EB','PO91AN','PO191HD',
              'SR81DS','SR31HU','SR13NE','SP12NW','WN67TB','WN68PA','IP11PH','BH63RE','BH220AN','BH241AX',
              'BH11AQ','BH37HG','BA140AE','BA151ET','GL91AL','GL205AE','GL80AN','BS140AG','BS394BB','BS273QW',
              'CB223AJ','CB74AF','CB80GQ','CB244TE','WR51AL','WR101AS','WR141EF','WR991YU','WR158HR','TQ110AE',
              'E20QQ','SY100AH','SY30AT','SY998AJ','M445AG','M320AT','M90PG','M250GR','M991BT','M380DD',
              'LA94AD','LA184AL','LA231AL','LA31BF','BN150AL','BN529BR','BN211DY','BN443GQ','CT154AR','CT201FH',
              'CT45GA','SW75NR','OX41DQ','CM131AB','CM186DT','CM210EP','CM981AR','CM20DG','CM164BT','CM11BW',
              'EH331BN','EH11BS','EH458AD','KW136YT','LL197DB','CF30AW','CF355AQ','DG125BA','G36DZ','G811BN',
              'BT119BS','BT118LU','BT118QU','BT274HF','BT440JB','AB101AF','AB510AG','N101AG','N31AJ','SA20AH']

    @property = Property.find(params[:id])
    @crime_rates = []
    @postcodes = postcodes.sample(10)
    @postcodes.each { |postcode| @crime_rates << scrape_crime(postcode).gsub(/All Crime & ASB/, '') }
  end

  private

  def scrape_crime(postcode)
    url = "https://www.ukcrimestats.com/Postcode/#{postcode}"
    html_file = open(url).read
    html_doc = Nokogiri::HTML(html_file)

    return html_doc.search('.ranktable tr:nth-child(4)').text.split("Detached").first
  end

  def search_house
    properties = []

    url = "https://www.zoopla.co.uk/for-sale/property/london/?q=London&results_sort=newest_listings&search_source=home"
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
      properties << property
      properties.take(10)
    end

    return properties
  end

  def property_params
    params.require(:property).permit(:name, :address, :price, :photo)
  end
end
