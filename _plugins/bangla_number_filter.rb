module Jekyll
  module BanglaNumberFilter
    def bangla_number(number)
      bangla_digits = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯']
      output = ""
      number.to_s.split('').each { |c|
        output << bangla_digits[c.to_i]
      }
      output
    end
  end
end

Liquid::Template.register_filter(Jekyll::BanglaNumberFilter)