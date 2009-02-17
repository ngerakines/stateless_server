%% Copyright (c) 2009 Nick Gerakines <nick@gerakines.net>
%%
%% Permission is hereby granted, free of charge, to any person
%% obtaining a copy of this software and associated documentation
%% files (the "Software"), to deal in the Software without
%% restriction, including without limitation the rights to use,
%% copy, modify, merge, publish, distribute, sublicense, and/or sell
%% copies of the Software, and to permit persons to whom the
%% Software is furnished to do so, subject to the following
%% conditions:
%%
%% The above copyright notice and this permission notice shall be
%% included in all copies or substantial portions of the Software.
%%
%% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
%% EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
%% OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
%% NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
%% HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
%% WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
%% FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
%% OTHER DEALINGS IN THE SOFTWARE.
%% @doc A small, no frills gen_server clone. 
%% @author Nick Gerakines <nick@gerakines.net>
-module(stateless_server).

-export([start/1, start_server/2, server_loop/1, behaviour_info/1, call/2]).

behaviour_info(callbacks) -> [{init, 1}, {handle, 2}];
behaviour_info(_) -> undefined.

%% @spec start(Module) -> pid()
%%       Module = atom()
%% @doc Starts the statless_server process with a given callback module.
start(Module) ->
    proc_lib:start_link(stateless_server, start_server,[self(), Module]).

%% @private
start_server(Parent, Module) ->
    try Module:init(Module) of
         ok ->
             proc_lib:init_ack(Parent, {ok, self()}),
            error_logger:info_report([stateless_server, {server_start, Module}, init_ok]),
            stateless_server:server_loop(Module);
        Response ->
            error_logger:error_report([stateless_server, {server_start, init_nok}, Response])
    catch
        Ma:Mi ->
            error_logger:error_report([stateless_server, {server_start, init_nok}, {Ma, Mi}])
    end.

%% @private
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

%% @spec call(To, Message) -> Response
%%       To = atom | pid()
%%       Message = any()
%%       Response = noreply | any()
%% @doc Sends a message to a stateless_server process.
call(To, Message) ->
    To ! {self(), Message},
    receive
        noreply -> noreply;
        {reply, Reply} -> Reply;
        Other -> Other
    end.
