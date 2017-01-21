module Jekyll
  module TeXyll
    class TeXBox
      def initialize(filename, unit = :ex)
        @metrics = Hash[YAML.load_file(filename).map do |(key, value)|
          [key.to_sym, value.chomp('pt').to_f]
        end]
        @metrics[:pt] ||= 1.0
        @unit = unit
      end

      def wd(unit = @unit)
        @metrics[:wd] / @metrics[unit]
      end

      def ht(unit = @unit)
        @metrics[:ht] / @metrics[unit]
      end

      def dp(unit = @unit)
        @metrics[:dp] / @metrics[unit]
      end
    end
  end
end
