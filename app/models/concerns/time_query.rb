# usage
# extend TimeQuery
module TimeQuery

  def between_range_column column_name, begin_at, end_at
    self.where("#{self.table_name}.#{column_name} BETWEEN ? AND ?", begin_at, end_at)
  end

  def day_range_column column_name, time = Time.now
    between_range_column(column_name, time.at_beginning_of_day, time.at_end_of_day)
  end

  def week_range_column column_name, time = Time.now
    between_range_column(column_name, time.at_beginning_of_week, time.at_end_of_week)
  end

  def month_range_column column_name, time = Time.now
    between_range_column(column_name, time.at_beginning_of_month, time.at_end_of_month)
  end

  def year_range_column column_name, time = Time.now
    between_range_column(column_name, time.at_beginning_of_year, time.at_end_of_year)
  end

end