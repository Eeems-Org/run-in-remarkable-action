# run-in-remarkable-action
Run a script in a remarkable tablet qemu image.

# Inputs
- `run` - Script to execute in the QEMU instance
- `setup` - Script to execute during docker image build so that it can be cached between runs
- `path` - Folder to sync with the device. This will be available at `/src`
- `fw_version` - reMarkable OS version to run in

# Usage
```yaml
- uses: Eeems-Org/run-in-remarkable-action@v1
  with:
    run: |
        set -eu
        cd /src
        echo "Installing dependencies"
        python -m pip install -r requirements.txt
        echo "Building codexctl"
        python -m PyInstaller \
          --noconfirm \
          --runtime-tmpdir /tmp \
          --onefile \
          --strip \
          codexctl.py
    setup: |
        set -eu
        opkg update
        echo "Installing basic build tools"
        opkg install \
          gcc \
          binutils \
          busybox \
          gawk \
          ldd \
          make \
          sed \
          tar \
          patchelf
        echo "Installing recommended build tools"
        opkg --force-overwrite \
          install \
          coreutils-install \
          diffutils \
          ldconfig \
          patch \
          pkg-config
        echo "Installing automake, cmake, meson, and ninja"
        opkg install \
          automake \
          libintl-full \
          libtool-bin \
          cmake \
          icu \
          libopenssl \
          bash \
          git \
          git-http python3-pip \
          python3-setuptools \
          coreutils-od \
          python3-psutil \
          python3-bcrypt \
          python3-cryptography
        python3 -m pip install -U wheel
        cd /opt/tmp
        git clone https://github.com/ninja-build/ninja.git
        cd ./ninja
        git checkout release
        CONFIG_SHELL=/opt/bin/bash python3 ./configure.py --bootstrap
        install -Dm0755 -t /opt/bin ./ninja
        cd /opt/tmp
        rm -Rf /opt/tmp/ninja
        python3 -m pip install -U meson
        echo "Installing header files"
        opkg install --force-overwrite --force-reinstall \
          libncurses-dev \
          libxml2-dev \
          python3-dev \
          ruby-dev \
          zlib-dev
        /opt/bin/busybox wget -qO- "$(/opt/bin/busybox sed -Ene \
          's|^src/gz[[:space:]]entware[[:space:]]https?([[:graph:]]+)|http\1/include/include.tar.gz|p' \
          /opt/etc/opkg.conf)" | /opt/bin/busybox tar x -vzC /opt/include
        echo "Installing python dependencies"
        opkg install \
          python3-cryptography \
          python3-bcrypt \
          python3-requests \
          python3-psutil
        ln -s /opt/lib/libffi.so.8 /opt/lib/libffi.so
        python3 -m pip install -U \
          pip \
          setuptools \
          pyinstaller

```
