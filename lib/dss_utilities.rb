module DssUtilities
  def parseDate(date, options={})
    if date
      res = Time.at(date.split("(")[1].split(")")[0].to_i/1000).to_date
      if options[:dates_as_string]
        res.to_s
      else
        res
      end
    end
  end
end
