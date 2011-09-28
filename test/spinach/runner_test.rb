require_relative '../test_helper'

describe Spinach::Runner do
  before do
    Spinach.reset_features
    @feature = Class.new(Spinach::Feature) do
      feature "A new feature"
      When "I say hello" do
        @when_called = true
      end
      Then "you say goodbye" do
        @then_called = true
        true.must_equal false
      end
      attr_accessor :when_called, :then_called
    end
    data = {
      'name' => "A new feature",
      'elements' => [
        {'name' => 'First scenario', 'steps' => [
          {'keyword' => 'When ', 'name' => "I say hello"},
          {'keyword' => 'Then ', 'name' => "you say goodbye"}]
        }
      ]
    }
    @runner = Spinach::Runner.new(data)
  end

  describe "#initialize" do
    it 'sets a default step_definition_path' do
      @runner.step_definitions_path.must_equal Spinach.config.step_definitions_path
    end

    it 'sets a default support_path' do
      @runner.support_path.must_equal Spinach.config.support_path
    end

    it 'allows to customize a step_definition_path' do
      @runner = Spinach::Runner.new(stub_everything, step_definitions_path: 'my/path')

      @runner.step_definitions_path.must_equal 'my/path'
    end

    it 'allows to customize a support_path' do
      @runner = Spinach::Runner.new(stub_everything, support_path: 'my/path')

      @runner.support_path.must_equal 'my/path'
    end

    it 'sets a default reporter' do
      @runner.reporter.must_be_kind_of Spinach::Reporter
    end
  end

  describe "#feature" do
    it "returns a Spinach feature" do
      @runner.feature.ancestors.must_include @feature
    end
  end

  describe "#scenarios" do
    it "should return the scenarios" do
      @runner.scenarios.must_equal [
        {'name' => 'First scenario', 'steps' => [
          {'keyword' => 'When ', 'name' => "I say hello"},
          {'keyword' => 'Then ', 'name' => "you say goodbye"}]
        }
      ]
    end
  end

  describe "#run" do
    it "should hook into the reporter" do
      reporter = stub_everything
      @runner.stubs(reporter: reporter)
      reporter.expects(:feature).with("A new feature")
      reporter.expects(:end).once
      @runner.run
    end
  end

end
