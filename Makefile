LIBDIR=`erl -eval 'io:format("~s~n", [code:lib_dir()])' -s init stop -noshell`
VERSION=0.1.1

all:
	mkdir -p ./ebin/
	(cd src; $(MAKE))

clean:
	(cd src; $(MAKE) clean)

package: clean
	@mkdir stateless_server-$(VERSION)/ && cp -rf src examples support Makefile stateless_server-$(VERSION)
	@COPYFILE_DISABLE=true tar zcf stateless_server-$(VERSION).tgz stateless_server-$(VERSION)
	@rm -rf stateless_server-$(VERSION)/

install:
	mkdir -p $(prefix)/$(LIBDIR)/stateless_server-$(VERSION)/ebin
	for i in ebin/*.beam; do install $$i $(prefix)/$(LIBDIR)/stateless_server-$(VERSION)/$$i ; done`