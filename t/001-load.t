#!/usr/bin/env escript
%% -*- erlang -*-
%%! -pa ./ebin -sasl sasl_error_logger false

main(_) ->
    etap:plan(1),
    etap_can:loaded_ok(
        stateless_server,
        lists:concat(["Module '", stateless_server, "' loaded."])
    ),
    etap:end_tests().
