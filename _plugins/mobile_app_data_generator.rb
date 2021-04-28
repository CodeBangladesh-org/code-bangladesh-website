module MobileAppDataGeneratorPlugin

  class Generator < Jekyll::Generator
    def generate(site)

      courses = []
      categories = Common.read_categories(site)
      categories.each do | category |
        courses += Common.read_category_courses(site, category["id"])
      end

      conf = Jekyll.configuration({})
      payload_obj = {
        "header_text" => conf["header_text"],
        "description" => conf["description"],
        "categories" => categories,
        "courses" => courses
      }

      Common.generate_json(site, "app-data", payload_obj)
      puts "Mobile data generated successfully."
    end

  end
end
