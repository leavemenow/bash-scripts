grep -oE '(https?://)?[a-zA-Z0-9.-]+\.[a-z]{2,}(\/\S*)?' index.html | sort -u

