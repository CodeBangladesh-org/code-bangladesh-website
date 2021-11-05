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

  class CompaniesPage < Jekyll::Page
    def initialize(site, base, dir, name, category, all_companies)
      @site = site
      @base = base
      @dir = dir
      @name = name
      self.process(name)
      self.read_yaml(File.join(base, "_layouts"), "companies-page.html")
      self.data.merge!({ "category" => category, "all_companies" =>  all_companies})
    end
  end

  class Generator < Jekyll::Generator
    def generate(site)
      categories = Common.read_categories(site)
      categories.each do | category |
        courses = Common.read_category_courses(site, category["id"])
        topics = Common.read_category_topics(site, category["id"])
        generate_category_pages(site, category, courses, topics)
        generate_courses_pages(site, category, courses)
        generate_topics_pages(site, topics)
        generate_companies_by_tech_pages(site, category)
      end
      generate_all_companies_page(site)
      puts "Category, Course and Company pages generated successfully from data `_data`"
    end

    private

    def generate_category_pages(site, category, courses, topics)
      site.pages << CategoryPage.new(site, site.source, '', category["id"] + "-courses" + '.html', category, courses, topics)
    end

    def generate_courses_pages(site, category, courses)
      courses.each do | course |
        site.pages << CoursePage.new(site, site.source, category["id"], course["id"] + '.html', course)
      end
    end

    def generate_topics_pages(site, topics)
      topics.each do | topic |
        site.pages << TopicPage.new(site, site.source, 'topics', topic["filename"] + '.html', topic, topic["courses"])
      end
    end

    def generate_companies_by_tech_pages(site, category)
      site.pages << CompaniesPage.new(site, site.source, '', "tech-companies-use-" + category["id"] + '.html', category, nil)
    end

    def generate_all_companies_page(site)
      # site.data["companies"] getting data from companies.csv
      site.pages << CompaniesPage.new(site, site.source, '', "tech-companies-in-bangladesh.html", nil, CompanyUtils.read_companies_csv_as_CompanyDto)
    end

  end
end
