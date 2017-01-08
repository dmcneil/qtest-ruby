module QTest
  class TestSuite < QTest::Base
    attr_accessor :id, :project, :test_cycle, :release

    def initialize(opts = {})
      @id = opts[:id]
      @project = opts[:project]
      @test_cycle = opts[:test_cycle]
      @release = opts[:release]
    end

    def test_runs
      test_runs = self.class.client.test_runs(project: @project.id,
                                              test_suite: @id) || []

      test_runs.map do |test_run|
        test_run.project = @project
        test_run.test_suite = self
        test_run.release = @release

        test_run
      end
    end

    def move(opts = {})
      if opts[:test_cycle]
        move_to_test_cycle(opts[:test_cycle])
      elsif opts[:release]
        move_to_release(opts[:release])
      end

      self
    end

    private

    def move_to_test_cycle(test_cycle_id)
      self.class.client.move_test_suite(project: @project.id,
                                        test_suite: @id,
                                        test_cycle: test_cycle_id)

      self.test_cycle = self.class.client.test_cycle({
        project: @project.id,
        test_cycle: test_cycle_id
      })
    end

    def move_to_release(release_id)
      self.class.client.move_test_suite(project: @project.id,
                                        test_suite: @id,
                                        release: release_id)

      self.release = self.class.client.release(project: @project.id,
                                               release: release_id)
    end
  end
end
