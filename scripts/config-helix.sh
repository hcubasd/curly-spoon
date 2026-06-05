readonly MACHINE_ARCH="$(uname -m)"

# bash
npm i -g bash-language-server
if ! command -v shfmt; then
	ARCH=$([[ $MACHINE_ARCH == "x86_64" ]] && echo "amd64" || echo "arm64")
	curl -Lo /usr/local/bin/shfmt "https://github.com/mvdan/sh/releases/download/v3.13.1/shfmt_v3.13.1_linux_${ARCH}" &&
		chmod +x /usr/local/bin/shfmt
fi

# toml
if ! command -v taplo; then
	curl -fsSL "https://github.com/tamasfe/taplo/releases/latest/download/taplo-linux-${MACHINE_ARCH}.gz" |
		gzip -d - | install -m 755 /dev/stdin /usr/local/bin/taplo
fi
if ! command -v tombi; then
	export PATH="$PATH:/root/.local/bin"
	curl -fsSL https://tombi-toml.github.io/tombi/install.sh | sh
fi

# yaml
npm i -g yaml-language-server @ansible/ansible-language-server
if ! command -v yamlfmt; then
	ARCH=$([[ $MACHINE_ARCH == "aarch64" ]] && echo "arm64" || echo "x86_64")
	curl -L "https://github.com/google/yamlfmt/releases/download/v0.21.0/yamlfmt_0.21.0_Linux_${ARCH}.tar.gz" |
		tar -xzf - -C /usr/local/bin yamlfmt
fi

# docker-compose
npm i -g @microsoft/compose-language-service

# dockerfile
npm i -g dockerfile-language-server-nodejs

# sql
if ! command -v sqls; then
	curl -Lo /tmp/sqls.zip https://github.com/sqls-server/sqls/releases/download/v0.2.45/sqls-linux-0.2.45.zip &&
		unzip -o /tmp/sqls.zip sqls -d /usr/local/bin &&
		rm /tmp/sqls.zip
fi
python -m pip install -U pip sqlfluff
