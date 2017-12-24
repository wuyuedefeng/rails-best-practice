module Utils::Excel
  class << self
    def export_excel(items, klass, file_name = nil, columns = nil)
      columns ||= klass::EXPORT_COLUMNS
      file_name ||= klass.to_s.downcase.pluralize

      workbook = RubyXL::Workbook.new
      worksheet = workbook.worksheets[0]

      columns.each_with_index do |e, i|
        worksheet.add_cell(0, i, e)
      end

      items.each_with_index do |item, row|
        columns.each_with_index do |key, col|
          worksheet.add_cell(row + 1, col, item.try(key))
        end
      end
      workbook.write("tmp/#{file_name}.xlsx")
    end

    def load_excel_data(file)
      workbook = RubyXL::Parser.parse(file)
      worksheet = workbook.worksheets[0]

      columns = worksheet[0].cells.each_with_object([]) do |cell, a|
        value = cell && cell.value
        a.push(value.to_sym) if value.present?
      end

      data = []
      worksheet.each_with_index { |row, index|
        next if index == 0
        hash = {}
        row && row.cells.each_with_index { |cell, index|
          val = cell && cell.value
          hash[columns[index]] = val
        }
        data.push(hash)
      }
      data
    end
  end
end