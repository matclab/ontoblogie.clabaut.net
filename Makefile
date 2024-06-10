all:
	nikola build && pagefind --site output && nikola deploy
