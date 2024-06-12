module BxBlockFilterItems
  class ApplicationFilter
    attr_accessor :active_record, :query_params, :date_format

    def initialize(active_record, query_params)
      @active_record = active_record
      @query_params = query_params || {}
      if !@query_params.is_a?(Hash)
        @query_params = @query_params.permit!.to_h.deep_symbolize_keys
      end
    end

    def call
      query_params.present? ?
        active_record.where(query_string) : active_record.all
    end

    private

    def query_string
      query_str = ""
      query_params.each_with_index do |(key, value), index|
        next if value.blank?
        # if query_str.present?
        #   query_str += " AND "
        # end
        _query_str = query_string_for(key, value)
        
        if _query_str.present?
          query_str += " AND " if query_str.present?
          query_str += _query_str
        end
      end

      query_str
    end

    def query_string_for(attr_name, value)
      raise "Must be implemented in derived class"
    end
  end
end
