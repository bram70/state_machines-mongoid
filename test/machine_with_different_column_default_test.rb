require_relative 'test_helper'

class MachineWithDifferentColumnDefaultTest < BaseTestCase
  def setup
    @original_stderr, $stderr = $stderr, StringIO.new

    @model = new_model do
      field :status, :type => String, :default => 'idling'
    end
    @machine = StateMachines::Machine.new(@model, :status, :initial => :parked)
    @record = @model.new
  end

  def test_should_use_machine_default
    assert_equal 'parked', @record.status
  end

  def test_should_generate_a_warning
    assert_match(/Both MongoidTest::Foo and its :status machine have defined a different default for "status". Use only one or the other for defining defaults to avoid unexpected behaviors\./, $stderr.string)
  end

  def teardown
    $stderr = @original_stderr
    super
  end
end