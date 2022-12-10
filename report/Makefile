open: main.pdf
	evince main.pdf

main.pdf: main.tex
	R --vanilla -q -e "tinytex::latexmk('main.tex', engine='pdflatex')" 

.PHONY: clean
clean:
	rm main.pdf
