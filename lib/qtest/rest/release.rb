module QTest
  module REST
    module Release
      include QTest::REST::Utils

      def release(args={})
        path = build_path('/api/v3/projects', args[:project], 'releases', args[:id])
        response = handle_response(self.class.get(path))
        deserialize_response(response, QTest::Release)
      end

      def releases(args={})
        path = build_path('/api/v3/projects', args[:project], 'releases')
        response = handle_response(self.class.get(path))
        deserialize_response(response, QTest::Release)
      end
    end
  end
end
