module Common

  def self.read_categories(site)
    categories = []
    category_dir_items = site.data["categories"]
    category_dir_items.each do | category_item |
      # For some reason, category_item is an array, first item is the filename and second item is content
      file_name = category_item[0] + '.yml'
      category = category_item[1]
      category["filename"] = file_name
      categories << category
    end

    categories = sort_categories_by_filename_prefix(categories)
    categories
  end

  def self.read_category_courses(site, category_id)
    courses = []
    category_course_dir_items = site.data["courses"][category_id]
    if category_course_dir_items != nil
      category_course_dir_items.each do | course_item |
        # For some reason, course_item is an array, first item is the filename and second item is content
        file_name = course_item[0] + '.yml'
        course = course_item[1]
        course["filename"] = file_name
        courses << course
      end
    end
    courses = sort_courses_by_filename_prefix(courses)
    courses
  end

  def self.read_category_topics(site, category_id)
    courses = read_category_courses(site, category_id)
    topics = {}
    courses.each do | course |
      course["topics"].each do | topic |
        if topics[topic] == nil
          topics[topic] = 1
        else
          topics[topic] += 1
        end
      end
    end

    topics = sort_topics_by_matched_total_course(topics)

    category_topics = []
    topics.each do | topic |
      topic_courses = []
      courses.each do | course |
        if course["topics"].include?(topic[0])
          topic_courses << course
        end
      end
      topic_name = topic[0].dup
      filename = to_slug(topic_name) #to_slug(URI::encode(topic_name.force_encoding('ASCII-8BIT')))
      category_topics << { "topic_name" => topic_name,
                           "number_of_courses" => topic[1],
                           "courses" => topic_courses,
                           "filename" => filename
      }
    end

    category_topics
  end

  def self.sort_categories_by_filename_prefix(categories)
    #puts "1-what-to-learn.yml"[0,"1-what-to-learn.yml".index('-')].to_i
    categories.sort_by { |hash| hash["filename"][0, hash["filename"].index('-')].to_i }
  end

  def self.sort_courses_by_filename_prefix(courses)
    courses.sort_by { |hash| hash["filename"][0, hash["filename"].index('-')].to_i }
  end

  def self.sort_topics_by_matched_total_course(category_topics)
    category_topics.sort_by {|_key, value| value}.reverse
  end

  def self.to_bangla_number(number)
    bangla_digits = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯']
    output = ""
    number.to_s.split('').each { |c|
      output << bangla_digits[c.to_i]
    }
    output
  end

  def self.to_slug(value)
    value.gsub!(/[']+/, '')
    value.gsub!(/[&]+/, 'and')
    value.gsub!(/[*]+/, 'star')
    value.strip!
    value.gsub!(' ', '-')
    value
  end
end