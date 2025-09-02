# Viaplay-Tech-Test
SwiftUI iOS app · scalable modular architecture with API + offline-first

## Technical change log

### 🚀 Continuous Integration (CI) with GitHub Actions

**Goal.** Automatically validate that the project builds and passes tests before merging PRs from `feature/*` or `fix/*` branches.

**When it runs.**
- `pull_request` ➜ target `develop` (when the PR is opened/updated).
- `workflow_dispatch` ➜ manual run from the UI.

**Path filters.** Triggers on changes under `Viaplay/**` or `.swiftlint.yml` (ignores `*.md`).

**Runner.** `macos-15` with Xcode `latest-stable`.

**Environment variables.**
- `SCHEME`: `Viaplay`
- `PROJECT`: `Viaplay/Viaplay.xcodeproj`
- `DESTINATION`: `platform=iOS Simulator,name=iPhone 16 Pro,OS=latest`

**What the workflow does.**
1. Checks out the repository.
2. Selects the latest stable Xcode.
3. Caches SPM/DerivedData to speed up builds.
4. Installs SwiftLint and runs it with `--strict` in `Viaplay`.
5. Builds and runs unit tests (only `ViaplayTests`) with code coverage and `-skipMacroValidation`.
6. Uploads the `.xcresult` as an artifact even on failure.

**File.** `.github/workflows/ci.yml`

**Badge (optional).** Add to the README:
```md
![iOS CI](https://github.com/<org>/<repo>/actions/workflows/ci.yml/badge.svg)
```

**Quick local run.**
```bash
xcodebuild \
  -project Viaplay/Viaplay.xcodeproj \
  -scheme Viaplay \
  -destination 'platform=iOS Simulator,name=iPhone 16 Pro,OS=latest' \
  clean test
```

—

### 🧹 Linting with SwiftLint

**Goal.** Align code with style and best practices; catch issues early and keep PRs clean.

**Local install.**
```bash
brew install swiftlint
swiftlint version
```

**File.** `.swiftlint.yml`

**Scope.**
- `included`: `Viaplay`
- `excluded`: `Carthage`, `Pods`, `DerivedData`, `ViaplayTests`, `*.generated.swift`, `*.pb.swift`

**Disabled rules.** `trailing_whitespace`, `todo`, `identifier_name`.

**Opt‑in rules (selection).** `sorted_imports`, `force_unwrapping`, `implicit_return`, `switch_case_on_newline`, `collection_alignment`, `modifier_order`, `vertical_whitespace_*`.

**Limits and metrics.**
- `line_length` 120/160 (ignores URLs/signatures/comments)
- `type_body_length` 300/400
- `function_body_length` 50/100
- `function_parameter_count` 5/8
- `cyclomatic_complexity` 10/20
- `nesting` type 3/6 · statements 5/10

**Conventions.**
- Names: tuned `identifier_name`; exceptions `id`, `URL`, `GlobalAPIKey`.
- Types: `type_name` min/max lengths.
- Header: enforced `file_header.required_pattern` for project `.swift` files.
- Reporter: `xcode` for readable output in local/CI.

**How to run.**
- Local: from the repo root
```bash
swiftlint --strict
```
- CI: dedicated step in the workflow (see CI section).

**Xcode integration (Run Script).** Add a phase before `Compile Sources`:
```bash
if which swiftlint >/dev/null; then
  swiftlint
else
  echo "warning: SwiftLint not installed. Run 'brew install swiftlint'"
fi
```
```