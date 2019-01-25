require_relative "../helper"

describe Sfn::Planner do
  let(:api) do
    unless @api
      @api = mock
    end
    @api
  end
  let(:default_stack_data) do
    Smash.new(
      :id => "_TEST_ID_",
      :name => "_TEST_NAME_",
    )
  end
  let(:stack_data) { Smash.new }
  let(:stack) do
    unless @stack
      @stack = Miasma::Models::Orchestration::Stack.new(
        api, default_stack_data.merge(stack_data)
      ).valid_state
      @stack.parameters = stack_parameters
    end
    @stack
  end
  let(:stack_parameters) { Smash.new }
  let(:config) { Smash.new }
  let(:arguments) { [] }
  let(:options) { Smash.new }
  let(:planner_type) { Sfn::Planner }
  let(:planner) do
    planner_type.new(ui, config, arguments, stack, options)
  end

  it "should raise error on plan generation" do
    -> { planner.generate_plan({}, {}) }.must_raise NotImplementedError
  end

  describe Sfn::Planner::Aws do
    let(:stack_data) do
      Smash.new(
        :parameters => {},
        :template => {},
      )
    end
    let(:planner_type) { Sfn::Planner::Aws }

    before do
      api.expects(:aws_region).returns("us-west-2").at_least_once
      api.expects(:stack_reload).at_least_once
    end

    it "should return empty plan when templates are empty" do
      api.expects(:stack_template_load).returns({}).at_least_once
      result = planner.generate_plan({}, {})
      result.must_be :empty?
    end

    describe "XXX 1" do
      before do
        api.expects(:data).returns({}).at_least_once
      end

      let(:template) do
        Smash.new(
          "Parameters" => {
            "Param" => {
              "Type" => "String",
              "AllowedValues" => ["1", "5", "4", "2", "3"] # XXX: 1
            },
          }
        )
      end

      describe "XXX 2" do
        let(:stack_parameters) do
          Smash.new("Param" => "1")
        end

        it "XXX" do
          api.expects(:stack_template_load).returns(
            Smash.new(
              "Parameters" => {
                "Param" => {
                  "Type" => "String",
                  "AllowedValues" => ["2", "4", "1", "3", "5"] # XXX: 1
                },
              },
            )
          ).at_least_once
          result = planner.generate_plan(template, Smash.new("Param" => "2")).stacks[stack.name]
        end
      end
    end
    # XXX
  end
end
