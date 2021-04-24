module DynamicPagesPlugin

  class CategoryPage < Jekyll::Page
    def initialize(site, base, dir, name, category, courses, topics)
      @site = site
      @base = base
      @dir  = dir
      @name = name
      self.process(name)
      self.read_yaml(File.join(base, "_layouts"), "category-page.html")
      self.data.merge!({ "category"=>category, "courses"=>courses, "topics"=>topics })
    end
  end

  class CoursePage < Jekyll::Page
    def initialize(site, base, dir, name, course)
      @site = site
      @base = base
      @dir = dir
      @name = name
      self.process(name)
      self.read_yaml(File.join(base, "_layouts"), "course-page.html")
      self.data.merge!({ "course" => course })
    end
  end

  class TopicPage < Jekyll::Page
    def initialize(site, base, dir, name, topic, courses)
      @site = site
      @base = base
      @dir  = dir
      @name = name
      self.process(name)
      self.read_yaml(File.join(base, "_layouts"), "topic-page.html")
      self.data.merge!({ "topic"=>topic, "courses"=>courses })
    end
  end

  class Generator < Jekyll::Generator
    def generate(site)
      generate_homepage_json(site)
      categories = Common.read_categories(site)
      categories.each do | category |
        courses = Common.read_category_courses(site, category["id"])
        topics = Common.read_category_topics(site, category["id"])
        generate_category_pages(site, category, courses, topics)
        generate_courses_pages(site, category, courses)
        generate_topics_pages(site, topics)
      end
      puts "Category and Course pages generated successfully from data `_data`"
    end

    private

    def generate_homepage_json(site)
      conf = Jekyll.configuration({})
      site_obj = { "header_text" => conf["header_text"], "description" => conf["description"], "pretty_categories" => site.data["pretty_categories"] }
      Common.generate_json(site, "homepage", { "site" => site_obj })
    end

    def generate_category_pages(site, category, courses, topics)
      site.pages << CategoryPage.new(site, site.source, '', category["id"] + "-courses" + '.html', category, courses, topics)
      Common.generate_json(site, category["id"] + "-courses", { "category" => category, "courses" => courses, "topics" => topics })
    end

    def generate_courses_pages(site, category, courses)
      courses.each do | course |
        site.pages << CoursePage.new(site, site.source, category["id"], course["id"] + '.html', course)
        Common.generate_json(site, category["id"] + "/" + course["id"], { "course" => course })
      end
    end

    def generate_topics_pages(site, topics)
      topics.each do | topic |
        site.pages << TopicPage.new(site, site.source, 'topics', topic["filename"] + '.html', topic, topic["courses"])
        Common.generate_json(site, "topics/" + topic["filename"], obj = { "topic" => topic })
      end
    end

  end
end
