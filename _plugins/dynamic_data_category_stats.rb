module DynamicDataCategoryStatsPlugin

  class Generator < Jekyll::Generator
    def generate(site)
      populate_category_stats_dynamic(site)
    end

    private

    def populate_category_stats_dynamic(site)
      categories = Common.read_categories(site)
      site.data["pretty_categories"] = categories

      pretty_category_courses = {}
      categories.each do | category |
        courses = Common.read_category_courses(site, category["id"])
        pretty_category_courses[category["id"]] = courses
      end
      site.data["pretty_category_courses"] = pretty_category_courses

      # Calculating number_of_courses, number_of_videos and number_of_topics in a category
      site.data["pretty_categories"].each do | pretty_category |
        total_videos = 0
        total_topics = []
        total_number_of_courses_in_category = site.data["pretty_category_courses"][pretty_category["id"]]
        total_number_of_courses_in_category.each do | pretty_course |
          total_videos += pretty_course["number_of_videos"]
          total_topics += pretty_course["topics"]
        end
        pretty_category["number_of_videos"] = Common.to_bangla_number(total_videos)
        pretty_category["number_of_topics"] = Common.to_bangla_number(total_topics.uniq.size)
        pretty_category["number_of_courses"] = Common.to_bangla_number(total_number_of_courses_in_category.size)
      end
    end

  end
end
