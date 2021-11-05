class CompanyDto
    attr_reader :name, :office_location, :technologies, :technologies_array, :web_presence

    def initialize(name:, office_location:, technologies:, web_presence:)
      @name = name
      @office_location = office_location
      @technologies = technologies
      @technologies_array = technologies_arr
      @web_presence = web_presence
    end

    def use_technology?(technology_name)
      @technologies_array.include? technology_name
    end

    def to_liquid
      { "name" => @name, "technologies" => @technologies_array, "office_location" => @office_location, "web_presence" => @web_presence }
    end

    def to_s
      %(CompanyDto - [name: #{@name}, office_location: #{@office_location}, technologies: #{@technologies}, web_presence: #{@web_presence}])
    end

    def as_json(options={})
      {
        name: @name,
        technologies: @technologies_array,
        office_location: @office_location,
        web_presence: @web_presence
      }
    end

    def to_json(*options)
      as_json(*options).to_json(*options)
    end

    def technologies_arr
      items = @technologies.split(',')
      items = items.map { |item| item.strip }
      items = items.map { |item| item.end_with?('.')? item.chop! : item }
      items = items.map { |item| item.end_with?("etc")? item.chomp("etc") : item }
      items = items.reject { |item| item.empty? }
      items
    end
end
