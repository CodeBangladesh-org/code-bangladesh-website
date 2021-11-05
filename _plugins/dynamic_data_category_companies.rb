module DynamicDataCategoryCompaniesPlugin

  class Generator < Jekyll::Generator
    def generate(site)
      companies = CompanyUtils.read_companies_csv_as_CompanyDto
      tech_company_array_hash = get_technologies_companies_map(companies)

      categories = Common.read_categories(site)
      categories.each do |category|
        if category.key? "companies" and category["companies"] == "dynamic"
          category_companies = []
          if category.key? "popular_topics"
            category["popular_topics"].each do | popular_topic |
              if tech_company_array_hash.key?(popular_topic)
                category_companies << tech_company_array_hash[popular_topic]
              end
            end
          end
          category["companies"] = category_companies.flatten.uniq
        end
      end

    end

    private

    def get_technologies_companies_map(companies)
      hash = {}
      companies.each do | company |
        company.technologies_arr.each do | tech |
          if not hash.key?(tech)
            hash[tech] = [company]
          else
            hash[tech] = hash[tech] << company
          end
        end
      end
      hash
    end

  end
end
