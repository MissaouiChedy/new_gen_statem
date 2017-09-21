defmodule NewGenStatemTest.HumanStateMachineTest do
  use ExUnit.Case
  
  setup do
    on_exit fn ->
       NewGenStatem.HumanStateMachine.reset
    end
    :ok
  end
  
  test "initial state should be neutral" do
    assert NewGenStatem.HumanStateMachine.say_hello() == NewGenStatem.HumanStateMachine.neutral_message()
  end

  test "should be happy when praised more that insulted" do
    NewGenStatem.HumanStateMachine.praise()
    NewGenStatem.HumanStateMachine.praise()
    NewGenStatem.HumanStateMachine.praise()

    NewGenStatem.HumanStateMachine.insult()
    NewGenStatem.HumanStateMachine.insult()

    assert NewGenStatem.HumanStateMachine.say_hello() == NewGenStatem.HumanStateMachine.happy_message()
  end

  test "should be angry when insulted more that praised" do
    NewGenStatem.HumanStateMachine.praise()
    NewGenStatem.HumanStateMachine.praise()

    NewGenStatem.HumanStateMachine.insult()
    NewGenStatem.HumanStateMachine.insult()
    NewGenStatem.HumanStateMachine.insult()
    
    assert NewGenStatem.HumanStateMachine.say_hello() == NewGenStatem.HumanStateMachine.angry_message()
  end

  test "should return to netral angry when insulted and praised equally" do
    NewGenStatem.HumanStateMachine.praise()
    NewGenStatem.HumanStateMachine.praise()
    NewGenStatem.HumanStateMachine.praise()

    NewGenStatem.HumanStateMachine.insult()
    NewGenStatem.HumanStateMachine.insult()
    NewGenStatem.HumanStateMachine.insult()
    
    assert NewGenStatem.HumanStateMachine.say_hello() == NewGenStatem.HumanStateMachine.neutral_message()
  end
end
