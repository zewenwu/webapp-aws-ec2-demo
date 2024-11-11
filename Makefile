conda-setup:
	conda create -n pre-commit python=3.12 -y

conda-remove:
	conda remove -n pre-commit --all -y

setup-reqs:
	pip install pip-tools
	pip-compile reqs/requirements.in
	pip-sync reqs/requirements.txt

setup-pre-commit:
	pre-commit --version
	pre-commit install

run-pre-commit-all:
	pre-commit run --all-files
