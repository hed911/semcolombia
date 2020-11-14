module PostgresqlDumper

  def copy_to path = nil, options = {}, options_query
    connection = ActiveRecord::Base.connection
    options = {:delimiter => "|", :format => :csv, :header => true}.merge(options)
    options_string = if options[:format] == :binary
                       "BINARY"
                     else
                       "DELIMITER '#{options[:delimiter]}' CSV #{options[:header] ? 'HEADER' : ''}"
                     end
    if path
      raise "You have to choose between exporting to a file or receiving the lines inside a block" if block_given?
      connection.execute "COPY (#{options_query}) TO '#{sanitize_sql(path)}' WITH #{options_string}"
    else
      connection.raw_connection.copy_data "COPY (#{options_query}) TO STDOUT WITH #{options_string}" do
        while line = connection.raw_connection.get_copy_data do
          yield(line) if block_given?
        end
      end
    end
  end

  def copy_to_string options_query, options = {}
    data = "\xEF\xBB\xBF"
    self.copy_to(nil, options, options_query){|l| data << l.force_encoding(Encoding::UTF_8) }
    data
  end

end
