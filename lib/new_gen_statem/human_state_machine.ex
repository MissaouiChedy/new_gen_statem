defmodule NewGenStatem.HumanStateMachine do
    
    @behaviour :gen_statem

    @name :human_statem
    
    def neutral_message, do: "Hello"
    def happy_message, do: "Oh Hi mark! What a funny story!"
    def angry_message, do: "Everybody betrayed me I'm fedup with this world!"
    

    def start_link do
        :gen_statem.start_link({:local, @name}, __MODULE__, [], [])
    end

    def init([]) do 
        {:ok, :neutral, %{insults: 0, praises: 0}}
    end

    def callback_mode do 
        :state_functions
    end

    def reset do
        :gen_statem.call(@name, :reset)
    end

    def say_hello do
        :gen_statem.call(@name, :hello)
    end

    def praise do
        :gen_statem.cast(@name, :praise)
    end

    def insult do
        :gen_statem.cast(@name, :insult)
    end

    def stop do
        :gen_statem.stop(@name)
    end

    def terminate(_reason, state, data) do
        IO.puts "Terminated with state: #{state}"
        IO.puts "Data:"
        IO.inspect data
        {:shutdown, []}
    end

    def neutral({:call, from}, :hello, data) do
        {:keep_state, data, [{:reply, from, neutral_message()}]}
    end

    def neutral(:cast, :praise, data) do
        {:next_state, :happy, increment_praises(data)}
    end

    def neutral(:cast, :insult, data) do
        {:next_state, :angry, increment_insults(data)}
    end

    def neutral({:call, from}, :reset, _data) do
        {:next_state, :neutral, %{insults: 0, praises: 0 }, [{:reply, from, :ok}]}
    end

    def happy({:call, from}, :hello, data) do
        {:keep_state, data, [{:reply, from, happy_message()}]}
    end

    def happy(:cast, :praise, data) do
        {:keep_state, increment_praises(data)}
    end

    def happy(:cast, :insult, data) do
        data
        |> increment_insults()
        |> handle_neutral_transition()
    end

    def happy({:call, from}, :reset, _data) do
        {:next_state, :neutral, %{insults: 0, praises: 0 }, [{:reply, from, :ok}]}
    end

    def angry({:call, from}, :hello, data) do
        {:keep_state, data, [{:reply, from, angry_message()}]}
    end

    def angry(:cast, :praise, data) do
        data
        |> increment_praises()
        |> handle_neutral_transition()
    end

    def angry(:cast, :insult, data) do
        {:keep_state, increment_insults(data)}
    end

    def angry({:call, from}, :reset, _data) do
        {:next_state, :neutral, %{insults: 0, praises: 0 }, [{:reply, from, :ok}]}
    end

    defp handle_neutral_transition(data = %{insults: insults, praises: praises}) 
        when insults == praises do
        {:next_state, :neutral , data}
    end

    defp handle_neutral_transition data do
        {:keep_state, data}
    end

    defp increment_insults data do
        %{ data | insults: data.insults + 1 }
    end

    defp increment_praises data do
        %{ data | praises: data.praises + 1 }
    end
end