all: monty_hall_selection.pdf posterior.pdf MontyHall_vs_Base.pdf

monty_hall_selection.pdf:
	julia monty_hall_selection.jl


posterior.pdf:
	python3 posterior.py

MontyHall_vs_Base.pdf:
	pdflatex MontyHall_vs_Base.tex
