-module(basic_server).
-behavior(stateless_server).

-export([init/1, handle/2, foo/1, good/1, thrown/1, sleep/1]).

init(_) ->
    ok.

handle(_From, {foo}) ->
    {reply, bar};

handle(_From, {thrown}) ->
    exit(wutt),
    {reply, ok};

handle(_From, {sleep}) ->
    timer:sleep(9000),
    {reply, ok};

handle(From, {evil}) ->
    From ! {reply, good},
    {reply, evil};

handle(_From, {none}) ->
    noreply.

foo(Pid) ->
    stateless_server:call(Pid, {foo}).

good(Pid) ->
    stateless_server:call(Pid, {evil}).

thrown(Pid) ->
    stateless_server:call(Pid, {thrown}).

sleep(Pid) ->
    stateless_server:call(Pid, {sleep}).
