[![Gem Version](https://badge.fury.io/rb/rggen-vhdl.svg)](https://badge.fury.io/rb/rggen-vhdl)
[![CI](https://github.com/rggen/rggen-vhdl/actions/workflows/ci.yml/badge.svg)](https://github.com/rggen/rggen-vhdl/actions/workflows/ci.yml)
[![Maintainability](https://api.codeclimate.com/v1/badges/d30b2c06ae3d7c0f254a/maintainability)](https://codeclimate.com/github/rggen/rggen-vhdl/maintainability)
[![codecov](https://codecov.io/gh/rggen/rggen-vhdl/branch/master/graph/badge.svg?token=cyo9R4xCje)](https://codecov.io/gh/rggen/rggen-vhdl)
[![Gitter](https://badges.gitter.im/rggen/rggen.svg)](https://gitter.im/rggen/rggen?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)

# RgGen::VHDL

RgGen::VHDL is a RgGen plugin to generate RTL written in VHDL.

## Installation

To install RgGen::VHDL, use the following command:

```
$ gem install rggen-vhdl
```

## Usage

You need to tell RgGen to load RgGen::VHDL plugin. There are two ways.

### Using `--plugin` runtime option

```
$ rggen --plugin rggen-vhdl your_register_map.yml
```

### Using `RGGEN_PLUGINS` environment variable

```
$ export RGGEN_PLUGINS=${RGGEN_PLUGINS}:rggen-vhdl
$ rggen your_register_map.yml
```

## Using Generated RTL

Generated RTL modules are constructed by using common VHDL modules.
You need to get them from the GitHub repository and set an envirnment variable to show their location.

* GitHub repository
    * https://github.com/rggen/rggen-vhdl-rtl.git
* Environment variable
    * RGGEN_VHDL_RTL_ROOT

```
$ git clone https://github.com/rggen/rggen-vhdl-rtl.git
$ export RGGEN_VHDL_RTL_ROOT=`pwd`/rggen-vhdl-rtl
```

Then, you can use generated RTL modules with your design. This is an example command.

```
$ simulator \
    -f ${RGGEN_VHDL_RTL_ROOT}/compile.f
    your_csr_0.vhd your_csr_1.vhd your_design.vhd
```

## Contact

Feedbacks, bus reports, questions and etc. are welcome! You can post them bu using following ways:

* [GitHub Issue Tracker](https://github.com/rggen/rggen/issues)
* [GitHub Discussions](https://github.com/rggen/rggen/discussions)
* [Chat Room](https://gitter.im/rggen/rggen)
* [Mailing List](https://groups.google.com/d/forum/rggen)
* [Mail](mailto:rggen@googlegroups.com)

## Copyright & License

Copyright &copy; 2021-2025 Taichi Ishitani. RgGen::VHDL is licensed under the [MIT License](https://opensource.org/licenses/MIT), see [LICENSE](LICENSE) for futher details.

## Code of Conduct

Everyone interacting in the RgGen::VHDL project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/rggen/rggen-vhdl/blob/master/CODE_OF_CONDUCT.md).
