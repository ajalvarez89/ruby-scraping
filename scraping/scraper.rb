require 'nokogiri'
require 'open-uri'
require 'csv'

class Scraper
  DEFAULT_OPTIONS = {
    base_url: 'https://colombia.craigslist.org/',
    path: 'search/apa?',
    parent: {
      element: 'ul',
      name: 'search-results',
      type: 'id'
    },
    targets: [
      { key: :title, element: 'a', name: 'result-title', type: :class },
      { key: :address, element: 'span', name: 'result-hood', type: :class },
      { key: :monthly_rent, element: 'time', name: 'result-date', type: :class },
    ]
  }

  attr_reader :options, :results

  def initialize
    @options = DEFAULT_OPTIONS
    @results = []
  end

  # @param element [String] the HTML element for the recurring parent element on the page
    # ex: 'div' or 'h1'
  # @param name [String] the class or id name we can target on the element.
    # ex: 'listingCard' if the class name for the element we want to target is 'listingCard'
  # @param type [Symbol] the HTML attribute type for the recurring parent element on the page
    # ex: :class or :id
  def build
    url = "#{@options[:base_url]}#{@options[:path]}min_bedrooms=3&max_bedrooms=3&max_bathrooms=2&min_bathrooms=2"

    data = scrape_page(url).css(parent_target)
    format_results(data)

    generate_csv(results)
  end

  # Specify the attribute type format needed for nokogiri data parsing
  #
  # @param type [Symbol] the attribute type on the html element
  # valid options currently are :class or :id
  # @return [String] the format needed for nokogiri data parsing ('.' for class or '#' for id)
  def set_attribute_type(type)
    type == :class ? '.' : '#'
  end

  # Set the parent element for nokogiri parsing
  # ex: 'div.listingCard'
  def parent_target
    parent = @options[:parent]

    return parent[:element] if parent[:name].nil? || parent[:type].nil?

    attribute_type = set_attribute_type(parent[:type])

    [parent[:element], attribute_type, parent[:name]].join
  end

  def scrape_page(url)
    Nokogiri::HTML(open(url))
  end

  def format_results(page_items)
    page_items.each { |page_item| @results << format_result(page_item) }
  end

  def format_result(page_item)
    @options[:targets].each_with_object({}) do |t, obj|
      next obj[t[:key]] = get_href_value(page_item) if t[:type] == :href

      type = set_attribute_type(t[:type])
      value = [t[:element], type, t[:name]].join

      obj[t[:key]] = page_item.css(value).text
    end
  end

  def get_href_value(page_item)
    page_item.css('a')[0].attributes['href'].value
  end

  def generate_csv(data)
    CSV.open('./hauses_exported.csv', 'wb') do |csv|
      csv << %w(title address monthly_rent)

      data.each do |column|
        csv << [column[:title], column[:address], column[:monthly_rent]]
      end
    end
  end
end

# Example:
scraper = Scraper.new
scraper.build
