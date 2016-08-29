#  PostgreSQL rules     -*- makefile -*-
#

ifndef ENV
  $(error "You must set the ENV variable")
endif
ifndef HOST
  $(error "You must set the HOST variable")
endif
ifndef PG_VERSION
  $(error "You must set the PG_VERSION variable")
endif
ifndef PG_SHORT_VERSION
  $(error "You must set the PG_SHORT_VERSION variable")
endif

postgresql: postgresql-repo postgresql-bin

postgresql-client: postgresql-repo postgresql-client-bin

postgresql-check: postgresql-repo-check postgresql-bin-check postgresql-contrib-check

postgresql-client-check: postgresql-repo-check postgresql-client-bin-check

postgresql-repo: /etc/apt/sources.list.d/pg.list

/etc/apt/sources.list.d/pg.list: ../../shared/postgresql/pg.list.m4
	../../shared/m4-conf -u root update shared/postgresql/pg.list $@ "-D__ENV__=${ENV}"
	sudo chmod 644 $@
	wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
	sudo apt-get update

postgresql-repo-check:
	../../shared/m4-conf -u root check shared/postgresql/pg.list /etc/apt/sources.list.d/pg.list "-D__ENV__=${ENV}"

postgresql-bin: postgresql-repo | /usr/lib/postgresql/${PG_SHORT_VERSION}/bin/postgres /usr/lib/postgresql/${PG_SHORT_VERSION}/bin/pg_archivecleanup

postgresql-client-bin: postgresql-repo | /usr/lib/postgresql/${PG_SHORT_VERSION}/bin/psql

/usr/lib/postgresql/${PG_SHORT_VERSION}/bin/postgres:
	yes Y | sudo apt-get install postgresql-${PG_SHORT_VERSION}

/usr/lib/postgresql/${PG_SHORT_VERSION}/bin/pg_archivecleanup:
	yes Y | sudo apt-get install postgresql-contrib-${PG_SHORT_VERSION}

/usr/lib/postgresql/${PG_SHORT_VERSION}/bin/psql:
	yes Y | sudo apt-get install postgresql-client-${PG_SHORT_VERSION}

postgresql-bin-check:
	@if ! /usr/lib/postgresql/${PG_SHORT_VERSION}/bin/postgres --version 2>&1 | grep $(PG_VERSION) >/dev/null ; then \
	    printf "\n\033[31m   *** ERROR *** PostgreSQL $(PG_VERSION)  is not installed \033[0m\n\n" ; \
	 fi

postgresql-contrib-check:
	@if [ ! -f /usr/lib/postgresql/${PG_SHORT_VERSION}/bin/pg_archivecleanup ]; then \
	    printf "\n\033[31m   *** ERROR *** PostgreSQL Contrib ${PG_SHORT_VERSION} is not installed \033[0m\n\n" ; \
	fi

postgresql-client-bin-check:
	@if !  /usr/lib/postgresql/${PG_SHORT_VERSION}/bin/psql --version 2>&1 | grep $(PG_VERSION) >/dev/null ; then \
	    printf "\n\033[31m   *** ERROR *** PostgreSQL Client $(PG_VERSION)  is not installed \033[0m\n\n" ; \
	 fi
