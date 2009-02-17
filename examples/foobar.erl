%% @doc A stateless_server example.
%%
%% {ok, Pid} = stateless_server:start(foobar).
%% noreply = stateless_server:call(Pid, baz).
%% stateless_server:call(foobar, <<"hello world">>).
-module(foobar).
-behavior(stateless_server).

-export([init/1, handle/2]).

init(XXX) ->
    register(foobar, self()),
    ok.

handle(_From, baz) ->
    noreply;
handle(_From, Message) ->
    {reply, <<"Fun times.">>}.
