module DssUtilities
  def parseDate(date)
    Time.at(date.split("(")[1].split(")")[0].to_i/1000).to_date.to_s if date
  end
end
