module MobileAppDataGeneratorPlugin

  class Generator < Jekyll::Generator
    def generate(site)

      categories = Common.read_categories(site)
      categories.each do | category |
        category["courses"] = Common.read_category_courses(site, category["id"])
        category["topics"] = Common.read_category_topics(site, category["id"])
      end

      # Delete category if no courses
      categories.delete_if { |category| category["courses"].size == 0 }

      conf = Jekyll.configuration({})
      payload_obj = {
        "headerText" => conf["header_text"],
        "description" => conf["description"],
        "categories" => categories
      }

      Common.generate_json(site, "app-data", payload_obj)
      puts "Mobile data generated successfully."
    end

  end
end