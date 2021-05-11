module MobileAppDataGeneratorPlugin

  # Note:
  #  number_of_videos in course is using English numerals and converted to Bangla in the mobile app
  #  However, number_of_courses, number_of_videos and number_of_topics is in Bangla numerals.
  #  Not need to convert on mobile app side.

  class Generator < Jekyll::Generator
    priority :lowest
    def generate(site)
      categories = Common.read_categories(site)
      categories.each do | category |
        category["courses"] = Common.read_category_courses(site, category["id"])
        category["topics"] = Common.read_category_topics(site, category["id"])
        category["number_of_courses"] = Common.to_bangla_number(category["courses"].size)

        # Count total videos and unique topics in a category
        total_videos = 0
        total_topics = []
        category["courses"].each do | course |
          total_videos += course["number_of_videos"]
          total_topics += course["topics"]
        end
        category["number_of_videos"] = Common.to_bangla_number(total_videos)
        category["number_of_topics"] = Common.to_bangla_number(total_topics.uniq.size)
      end

      # Delete category if no courses
      categories.delete_if { |category| category["courses"].size == 0 }

      conf = Jekyll.configuration({})
      site_conf = {
        "headerText" => conf["header_text"],
        "description" => conf["description"],
        "email" => conf["email"],
        "discordInvite" => conf["discord_invite"],
        "githubLink" => conf["github_link"],
      }
      payload_obj = {
        "siteConf" => site_conf,
        "categories" => categories
      }

      Common.generate_json(site, "app-data", payload_obj)
      puts "Mobile data generated successfully."
    end

  end
end
