-module(basic_server).
-behavior(stateless_server).

-export([init/1, handle/2, foo/1, good/1]).

init(_) ->
    ok.

handle(_From, {foo}) ->
    {reply, bar};

handle(From, {evil}) ->
    From ! {reply, good},
    {reply, evil};

handle(_From, {none}) ->
    noreply.

foo(Pid) ->
    stateless_server:call(Pid, {foo}).

good(Pid) ->
    stateless_server:call(Pid, {evil}).
