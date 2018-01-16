PROJ = rs232
SOURCES = rs232.v rs232rx.v indicator.v memory.v recorder.v replayer.v sequencer.v
SIM_RES = rs232rx_tb.vcd indicator_tb.vcd memory_tb.vcd replayer_tb.vcd \
          sequencer_tb.vcd recorder_tb.vcd \
          $(PROJ)_tb.vcd $(PROJ)_syntb.vcd
PIN_DEF = icestick.pcf
DEVICE = hx1k

-include config.mk

VIEW_GEN ?= iceview_html.py

all: $(PROJ).rpt $(PROJ).bin $(PROJ).html

test: $(SIM_RES)

$(PROJ).blif: $(SOURCES)
	yosys -p 'synth_ice40 -top top -blif $@' $^

# top level testbench needs all sources
$(PROJ)_tb: $(PROJ)_tb.v $(SOURCES)
	iverilog -o $@ $^

%.blif: %.v
	yosys -p 'synth_ice40 -top top -blif $@' $^

%.asc: $(PIN_DEF) %.blif
	arachne-pnr -d $(subst hx,,$(subst lp,,$(DEVICE))) -o $@ -p $^

%.bin: %.asc
	icepack $< $@

%.rpt: %.asc
	icetime -d $(DEVICE) -mtr $@ $<

%_tb: %_tb.v %.v
	iverilog -o $@ $^

%_tb.vcd: %_tb
	vvp -N $< +vcd=$@

%_syn.v: %.blif
	yosys -p 'read_blif -wideports $^; write_verilog $@'

%_syntb: %_tb.v $(PROJ)_syn.v
	iverilog -o $@ $^ `yosys-config --datdir/ice40/cells_sim.v`

%_syntb.vcd: %_syntb
	vvp -N $< +vcd=$@

%.html: %.asc
	$(VIEW_GEN) $^ $@

prog: $(PROJ).bin
	iceprog $<

sudo-prog: $(PROJ).bin
	@echo 'Executing prog as root!!!'
	sudo iceprog $<

clean:
	rm -f $(PROJ).blif $(PROJ).asc $(PROJ).rpt $(PROJ).bin $(PROJ)_syn* $(PROJ).html *.vcd

.SECONDARY:
.PHONY: all prog clean test
