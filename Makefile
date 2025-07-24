

.venv/bin/activate: .python-version
	python -m venv --clear .venv

.venv/bin/pip-compile: | .venv/bin/activate
	.venv/bin/python -m pip install --upgrade pip -q
	.venv/bin/python -m pip install pip-tools -q


requirements.txt: requirements.in pyproject.toml .python-version | .venv/bin/pip-compile
	.venv/bin/python -m pip install --upgrade pip -q
	.venv/bin/python -m piptools compile -o requirements.txt requirements.in --no-strip-extras -q
	.venv/bin/python -m piptools sync requirements.txt -q

dev: requirements.txt
	.venv/bin/python -m pip install -e .[dev] -q


test: pytest mypy ruff pyright

pytest:
	@.venv/bin/pytest || true
	@echo

mypy:
	@\
		printf "\033[0;36m" ;\
		echo "-mypy-" | sed -e :a -e "s/^.\{1,$$(tput cols)\}$$/ & /;ta" | tr ' ' = | tr - ' ' | head -c $$(tput cols) ;\
		printf "\033[0m\n"
	@.venv/bin/mypy . || true
	@printf "\033[0;36m" ; printf '%*s\n' "$${COLUMNS:-$$(tput cols)}" '' | tr ' ' = ; printf "\033[0m\n"

ruff:
	@\
		printf "\033[0;35m" ;\
		echo "-ruff-" | sed -e :a -e "s/^.\{1,$$(tput cols)\}$$/ & /;ta" | tr ' ' = | tr - ' ' | head -c $$(tput cols) ;\
		printf "\033[0m\n"
	@.venv/bin/ruff check || true
	@printf "\033[0;35m" ; printf '%*s\n' "$${COLUMNS:-$$(tput cols)}" '' | tr ' ' = ; printf "\033[0m\n"

pyright:
	@\
		printf "\033[0;33m" ;\
		echo "-pyright-" | sed -e :a -e "s/^.\{1,$$(tput cols)\}$$/ & /;ta" | tr ' ' = | tr - ' ' | head -c $$(tput cols) ;\
		printf "\033[0m\n"
	@.venv/bin/pyright . || true
	@printf "\033[0;33m" ; printf '%*s\n' "$${COLUMNS:-$$(tput cols)}" '' | tr ' ' = ; printf "\033[0m\n"

