module FetchTechCompanyDataPlugin

  class CompanyDto
    attr_reader :name, :office_location, :technologies, :web_presence

    def initialize(name:, office_location:, technologies:, web_presence:)
      @name = name
      @office_location = office_location
      @technologies = technologies
      @web_presence = web_presence
    end

    def to_s
      %(CompanyDto - [name: #{@name}, office_location: #{@office_location}, technologies: #{@technologies}, web_presence: #{@web_presence}])
    end
  end

  class Generator < Jekyll::Generator
    priority :lowest
    def generate(site)

      if already_downloaded?
        puts "Company data already downloaded from Github and saved in `_data/companies.csv`"
        return
      end

      doc = get_asciidoc_from_github()
      companies = prepare_categories_from_asciidoc(doc)
      write_company_data_csv(companies)
      puts "Company data downloaded successfully from Github and saved in `_data/companies.csv`"
    end

    private

    def get_asciidoc_from_github()
      uri = URI('https://raw.githubusercontent.com/MBSTUPC/tech-companies-in-bangladesh/master/README.adoc')
      res = Net::HTTP.get_response(uri)
      source = res.body if res.is_a?(Net::HTTPSuccess)
      Asciidoctor.load source, safe: :safe
    end

    def prepare_categories_from_asciidoc(doc)
      company_cells = []
      company_tables = doc.find_by(context: :table)
      company_tables.each do | company_table |
        company_cells << company_table.rows.body
      end
      company_cells.flatten!

      companies = []
      0.step(company_cells.length - 1, 4) do |row|
        companies << CompanyDto.new(
                       name: (company_cells[row + 0]).text,
                       office_location: company_cells[row + 1].text,
                       technologies: company_cells[row + 2].text,
                       web_presence: company_cells[row + 3].text,
                     )
      end
      companies
    end

    def write_company_data_csv(companies)
      Common.create_file("_data/companies", "csv")
      csv_string = CSV.generate do |csv|
        csv << ["কোম্পানির নাম", "ব্যাবহৃত টেকনোলোজি", "ওয়েব", "অফিসের ঠিকানা"]
        companies.each do | company |
          csv << [company.name, company.technologies, company.web_presence, company.office_location]
        end
      end
      Common.append_to_file("_data/companies.csv", csv_string)
    end

    def already_downloaded?
      File.file?("_data/companies.csv")
    end

  end
end
