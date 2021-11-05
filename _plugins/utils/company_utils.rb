class CompanyUtils
    def self.read_companies_csv_as_CompanyDto
      companies = []
      CSV.foreach("_data/companies.csv", headers: true, encoding:'ISO8859-1:utf-8') do |row|
        companies << CompanyDto.new(
          name: row[0],
          technologies: row[1],
          web_presence: row[2],
          office_location: row[3]
        )
      end
      companies
    end
end
