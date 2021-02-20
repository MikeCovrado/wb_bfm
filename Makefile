#Usage: iverilog [-EiSuvV] [-B base] [-c cmdfile|-f cmdfile]
#                [-g1995|-g2001|-g2005|-g2005-sv|-g2009|-g2012] [-g<feature>]
#                [-D macro[=defn]] [-I includedir] [-L moduledir]
#                [-M [mode=]depfile] [-m module]
#                [-N file] [-o filename] [-p flag=value]
#                [-s topmodule] [-t target] [-T min|typ|max]
#                [-W class] [-y dir] [-Y suf] [-l file] source_file(s)

# Little trick to evaluate SEED once and only once.
SEED ?= $(shell date +%N)
SEED := ${SEED}

.default: wb_bfm

wb_bfm:
	iverilog \
		-g2012 \
		-I ../../wb_common/master \
		../../vlog_tb_utils/master/vlog_tb_utils.v \
		bench/wb_bfm_tb.v \
		wb_bfm_master.v \
		wb_bfm_slave.v \
		wb_bfm_memory.v \
		wb_bfm_transactor.v \
		-s wb_bfm_tb \
		-o wb_bfm.out

run:
	./wb_bfm.out +transactions=10 +seed=$(SEED) +str_seed="$(SEED)" | tee wb_bfm_tb_$(SEED).log

clean_all:
	rm -f wb_bfm.out
	rm -f wb_bfm.tap
	rm -f wb_bfm.log
	rm -f wb_bfm_*.log
	rm -f wb_bfm_*.vcd

all: clean_all wb_bfm run
	ls -alt
