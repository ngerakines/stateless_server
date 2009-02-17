-module(stateless_server).

-export([start/1, start_server/1, server_loop/1, behaviour_info/1, call/2]).

behaviour_info(callbacks) -> [{init, 1}, {handle, 2}, {terminate, 1}];
behaviour_info(_) -> undefined.

start(Module) ->
    proc_lib:start(stateless_server, start_server,[Module]).

start_server(Module) ->
    try Module:init(Module) of
         ok ->
            proc_lib:init_ack(ok),
            error_logger:info_report([stateless_server, {server_start, Module}, init_ok]),
            stateless_server:server_loop(Module);
        Response ->
            error_logger:error_report([stateless_server, {server_start, init_nok}, Response])
    catch
        Ma:Mi ->
            error_logger:error_report([stateless_server, {server_start, init_nok}, {Ma, Mi}])
    end.

server_loop(Module) ->
    receive
        {From, Message} ->
            try Module:handle(From, Message) of
                noreply ->
                    From ! noreply;
                {reply, Reply} ->
                    From ! {reply, Reply};
                Other ->
                    From ! {unknown, Other}
            catch
                Ma:Mi ->
                    error_logger:error_report([stateless_server, Module, {Ma, Mi}]),
                    From ! {Ma, Mi}
            end;
        Message ->
            error_logger:report([stateless_server, Module, {unknown_message, Message}])
    end,
    stateless_server:server_loop(Module).

call(To, Message) ->
    To ! {self(), Message},
    receive
        noreply -> noreply;
        {reply, Reply} -> Reply;
        Other -> Other
    end.
