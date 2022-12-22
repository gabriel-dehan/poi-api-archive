json.count @history.count
json.data do 
  json.period @period 
  json.actions_count @user.impact.total_actions_per(@period)
  json.chart do
    json.type "bar"

    case @period
    when "global"
      json.x_axis I18n.t('date.abbr_month_names').compact.map(&:first).map(&:upcase)
    when "month"
      json.x_axis (1..Date.today.end_of_month.day).to_a
    when "week"
      json.x_axis I18n.t('date.abbr_day_names')
    end
    json.y_axis @user.impact.actions_count_per(@period)
  end

  json.history @history do |event| 
    json.partial! 'v1/events/show', event: event
  end
end