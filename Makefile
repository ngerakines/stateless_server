LIBDIR=`erl -eval 'io:format("~s~n", [code:lib_dir()])' -s init stop -noshell`

all:
	mkdir -p ./ebin/
	(cd src; $(MAKE))

clean:
	(cd src; $(MAKE) clean)

install: all
	mkdir -p ${LIBDIR}/stateless_server-0.1/ebin
	for i in ebin/*.beam; do install $$i $(LIBDIR)/stateless_server-0.1/$$i ; done
