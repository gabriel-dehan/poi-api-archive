json.data do
  @categories.each do |category|
    json.set!(category) do
      json.title I18n.t("categories.#{category}.title")
      json.description I18n.t("categories.#{category}.description")
    end
  end
end