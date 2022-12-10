main: p1.hex
	cp p1.hex ..

.PHONY: clean
clean:
	rm p1.raw p1.hex

simulation: p1.hex
	cp p1.hex ../simulation/modelsim/p1.hex

p1.raw: p1.ascii
	xxd -r $^ $@

p1.hex: p1.raw
	srec_cat $^ -binary -offset=0x0000 -o $@ -intel --line-length=44
