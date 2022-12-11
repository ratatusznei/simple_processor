open: main.pdf
	evince main.pdf

main.pdf: main.tex
	R --vanilla -q -e "tinytex::pdflatex('main.tex')" 

.PHONY: clean
clean:
	rm main.pdf
