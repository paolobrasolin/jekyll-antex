module Jekyll
  module TeX
    class TeXBox
      attr_reader :wd # width
      attr_reader :ht # height
      attr_reader :dp # depth
      attr_reader :th # total height = ht + dp

      def load_from_yml(filename)
        # get TeX metrics for box and convert them from (TeX) pt to ex
        metrics = YAML.load_file(filename)
        @ht = metrics['ht'] / metrics['ex']
        @dp = metrics['dp'] / metrics['ex']
        @wd = metrics['wd'] / metrics['ex']
        @th = metrics['th'] / metrics['ex']
      end
    end
  end
end
