# ============================================================================ #
#
#
#
# ---------------------------------------------------------------------------- #

.PHONY: all clean check FORCE
.DEFAULT_GOAL = all


# ---------------------------------------------------------------------------- #

PKG_CONFIG ?= pkg-config
UNAME      ?= uname
SQLITE3    ?= sqlite3
GREP       ?= grep


# ---------------------------------------------------------------------------- #

sqlite3_CFLAGS  ?= $(shell pkg-config --cflags sqlite3; )
sqlite3_LDFLAGS ?= $(shell pkg-config --cflags sqlite3; )


# ---------------------------------------------------------------------------- #

CFLAGS          ?=
CFLAGS          += -shared -fPIC -O2 $(sqlite3_CFLAGS)

LDFLAGS         ?=
LDFLAGS         += -shared $(sqlite3_LDFLAGS) -Wl,--no-undefined
LDFLAGS         += -Wl,--enable-new-dtags '-Wl,-rpath,$$ORIGIN/../lib'

ifneq (,$(DEBUG))
CFLAGS  += -ggdb3 -pg
LDFLAGS += -ggdb3 -pg
endif  # ifneq (,$(DEBUG))


# ---------------------------------------------------------------------------- #

OS ?= $(shell $(UNAME))
OS := $(OS)
ifndef libExt
ifeq (Linux,$(OS))
	libExt ?= .so
else
	libExt ?= .dylib
endif  # ifeq (Linux,$(OS))
endif  # ifndef libExt


# ---------------------------------------------------------------------------- #

.PHONY: lib
lib: libsqlexts$(libExt)
all: lib

libsqlexts$(libExt): hash_str.o
	$(LINK.c) $(filter %.o,$^) $(LDLIBS) -o "$@"



# ---------------------------------------------------------------------------- #

clean: FORCE
	-$(RM) *.o *.so *.dylib
	-$(RM) ./.tmpdb.db


# ---------------------------------------------------------------------------- #

check: libsqlexts$(libExt)
	-$(RM) ./.tmpdb.db
	$(SQLITE3) ./.tmpdb.db ".load ./libsqlexts"      \
	           "SELECT hash_str( 'Hello, World!' )"  \
	  |$(GREP) '^-6390844608310610124$$'



# ---------------------------------------------------------------------------- #
#
#
#
# ============================================================================ #
