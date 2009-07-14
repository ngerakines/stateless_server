#!/usr/bin/env escript
%% -*- erlang -*-
%%! -pa ./ebin -sasl sasl_error_logger false

main(_) ->
    etap:plan(3),
    {ok, ServerPid} = stateless_server:start(basic_server),
    etap:is(basic_server:foo(ServerPid), bar, "basic i/o"),
    etap:is(basic_server:good(ServerPid), evil, "hyjacked message"),
    etap:is(catch(basic_server:thrown(ServerPid)), {'EXIT', wutt}, "Exception caught"),
    etap:is(catch(basic_server:sleep(ServerPid)), {'EXIT', timeout}, "Exception caught (timeout)"),
    etap:end_tests().
