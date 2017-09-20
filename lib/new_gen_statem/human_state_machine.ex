defmodule NewGenStatem.HumanStateMachine do
    @behaviour :gen_statem

    @name :human_statem

    # Client API

    def start_link do
        :gen_statem.start_link({:local, @name}, __MODULE__, [], [])
    end

    def init([]) do 
        {:ok, :neutral, %{insults: 0, praises: 0}}
    end

    def callback_mode do 
        :state_functions
    end

    def say_hello do
        :gen_statem.call(@name, :hello)
    end

    def praise do
        :gen_statem.call(@name, :praise)
    end

    def insult do
        :gen_statem.call(@name, :insult)
    end

    def terminate(_reason, state, data) do
        IO.puts "Terminated with state: #{state}"
        IO.puts "Data:"
        IO.inspect data
        {:shutdown, []}
    end

    def neutral({:call, from}, :hello, data) do
        {:keep_state, data, [{:reply, from, "Hello"}]}
    end

    def neutral({:call, from}, :praise, data) do
        IO.puts "Praisin"
        {:next_state, :happy, %{ data | praises: data.praises + 1 }, [{:reply, from, :ok}]}
    end

    def neutral({:call, from}, :insult, data) do
        {:next_state, :angry, %{ data | insults: data.insults + 1 }, [{:reply, from, :ok}]}
    end


    def happy({:call, from}, :hello, data) do
        {:keep_state, data, [{:reply, from, "Oh Hi mark! What a funny story!"}]}
    end

    def happy({:call, from}, :praise, data) do
        {:keep_state, %{ data | praises: data.praises + 1 }, [{:reply, from, :ok}]}
    end

    def happy({:call, from}, :insult, data) do
        data = %{ data | insults: data.insults + 1 }
        if (data.insults == data.praises) do
            {:next_state, :neutral , data, [{:reply, from, :ok}]}
        else 
            {:keep_state, data, [{:reply, from, :ok}]}
        end
    end

    def angry({:call, from}, :hello, data) do
        {:keep_state, data, [{:reply, from, "Everybody betrayed me I'm fedup with this world!"}]}
    end

    def angry({:call, from}, :praise, data) do
        data = %{ data | praises: data.praises + 1 }
        if (data.insults == data.praises) do
            {:next_state, :neutral , data, [{:reply, from, :ok}]}
        else 
            {:keep_state, data, [{:reply, from, :ok}]}
        end
    end

    def angry({:call, from}, :insult, data) do
        {:keep_state, %{ data | insults: data.insults + 1 }, [{:reply, from, :ok}]}
    end

#     def push do
#         :gen_statem.call(@name, :push)
#     end

#     def get_count do
#         :gen_statem.call(@name, :get_count)
#     end

#     def stop do
#         :gen_statem.stop(@name)
#     end


#     # State functions

#   def off({:call, from}, :push, data), do: {:next_state, :on, data + 1, [{:reply, from, :on}]}
#   def off(event, content, data), do: handle_event(event, content, data)

#   def on({:call, from}, :push, data), do: {:next_state, :off, data + 1, [{:reply, from, :off}]}
#   def on(event, content, data), do: handle_event(event, content, data)

#   def handle_event({:call, from}, :get_count, data), do: {:keep_state, data, [{:reply, from, data}]}
#   def handle_event(_event, _content, data), do: {:keep_state, data}
end