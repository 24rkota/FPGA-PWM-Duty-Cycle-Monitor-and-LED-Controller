# Makefile for Nandland Go Board (Lattice iCE40HX1K)

PROJ = pwm_project
PIN_DEF = goboard.pcf
DEVICE = hx1k
PACKAGE = vq100

SRC = top.sv

all: $(PROJ).bin

$(PROJ).json: $(SRC)
	yosys -p "synth_ice40 -top top_pwm_controller -json $@" $(SRC)

$(PROJ).asc: $(PROJ).json $(PIN_DEF)
	nextpnr-ice40 --$(DEVICE) --package $(PACKAGE) --json $(PROJ).json --pcf $(PIN_DEF) --asc $@

$(PROJ).bin: $(PROJ).asc
	icepack $< $@

prog: $(PROJ).bin
	iceprog $<

clean:
	rm -f *.json *.asc *.bin

.PHONY: all prog clean