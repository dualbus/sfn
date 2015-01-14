require 'sfn'

module Sfn
  module Config
    # List command configuration
    class List < Bogo::Config

      attribute(
        :attribute, String,
        :multiple => true,
        :description => 'Attribute of stack to print'
      )
      attribute(
        :all_attributes, [TrueClass, FalseClass],
        :description => 'Print all available attributes'
      )
      attribute(
        :status, String,
        :multiple => true,
        :description => 'Match stacks with given status. Use "none" to disable.'
      )

    end
  end
end
