module QTest
  module REST
    module Release
      include QTest::REST::Utils
      include QTest::REST::CRUD

      def release(args={})
        path = build_path('/api/v3/projects',
                          args[:project],
                          'releases',
                          args[:id])
        get(QTest::Release, path)
      end

      def releases(args={})
        path = build_path('/api/v3/projects', args[:project], 'releases')
        get(QTest::Release, path)
      end
    end
  end
end
