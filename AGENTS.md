# AGENTS.md

## Project Overview

`openwrt-openwisp-monitoring` is the OpenWrt monitoring agent that collects device metrics and sends them to OpenWISP Monitoring.

Core code lives in `openwisp-monitoring/`:

- `files/` contains Lua code, shell scripts, UCI defaults, and runtime files installed on OpenWrt.
- `tests/` contains Lua and integration tests.
- `Makefile`, `runbuild`, `runtests`, `qa-format`, and `run-qa-checks` support package build, test, and QA workflows.

## Source of Truth

- Use `README.rst` and `docs/` for setup, package usage, and development workflows.
- Use `.github/workflows/ci.yml`, `.luacheckrc`, and package metadata for CI-tested build, QA, and test commands.
- Use GitHub issue/PR templates when asked to open issues or PRs.

If instructions conflict, repository config and CI workflows win first, docs next, and this file is supplemental.

## Development Notes

- Keep changes focused. Avoid unrelated refactors and formatting churn.
- Preserve UCI configuration compatibility, metric names, payload formats, package file paths, service behavior, and Monitoring API contracts unless explicitly required.
- Be careful with Lua code, shell scripts, network interfaces, metric collection, retry logic, buffering, and OpenWrt compatibility.
- Avoid unnecessary blank lines inside Lua functions and shell blocks.
- Update docs when behavior, settings, metrics, package options, setup steps, or supported OpenWrt versions change.

## Testing and QA

- Add or update tests for every behavior change.
- For bug fixes, write the regression test first, run it against the unfixed code, confirm it fails for the expected reason, then implement the fix.
- Use targeted tests while iterating, then run the documented full build/test command before considering the change complete.
- Run `./qa-format` and `./run-qa-checks` when present. Treat failures as blocking unless confirmed unrelated and reported.

## Security Notes

- Watch for command injection, unsafe shell expansion, leaked credentials, unsafe file permissions, excessive data collection, and broken auth flows.
- Preserve validation and safe handling around Monitoring URLs, shared secrets, certificates, UCI values, metric payloads, and shell commands.
- Write comments only when they explain why code is shaped a certain way. Put comments before the relevant block instead of scattering them inside it.

## Troubleshooting

- If setup, QA, builds, or tests fail, check docs first, then compare with CI. If commands diverge, follow CI.
