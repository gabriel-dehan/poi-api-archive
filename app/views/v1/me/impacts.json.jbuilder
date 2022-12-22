json.data do 
  json.global do   
    json.status @user.impact.get_status
    json.level @user.impact.level
    json.earned_points @user.impact.earned_points.floor
    json.spent_points @user.impact.spent_points.floor
    json.current_points @user.impact.current_points.floor
    json.current_cycle do
      json.points @user.impact.current_cycle.earned_points.floor
      json.maximum_points @user.impact.current_cycle.maximum_points.floor
    end
  end
  
  # TODO: Document
  json.categories do 
    @user.categorized_impacts.each do |categorized_impact|
      json.set! categorized_impact.id do
        json.level categorized_impact.level
        json.earned_points categorized_impact.earned_points.floor
        json.current_cycle do 
          json.points categorized_impact.current_cycle.earned_points.floor
          json.maximum_points categorized_impact.current_cycle.maximum_points.floor
        end
        json.category do 
          json.uid categorized_impact.category
          json.title I18n.t("categories.#{categorized_impact.category}.title")
          json.description I18n.t("categories.#{categorized_impact.category}.description")
          if categorized_impact.category == "bonus"
            json.actions I18n.t("categories.#{categorized_impact.category}.actions") do |action|
              json.title action[:title]
              json.reward Event::StaticImpacts[action[:event]]
            end
          end
        end
      end
    end
  end
  

  json.statuses_list do 
    Impact::GAUGE_LEVELS.each do |level, level_name|
      json.set!(level_name, {
        name: level_name.split("_").map(&:capitalize).join(" "),
        level_threshold: level
      })
    end
  end
end