---
name: fix-github-issue
description: "End-to-end workflow for triaging, reproducing, fixing, and shipping a GitHub issue. Use when the user provides a GitHub issue URL or issue number and asks to investigate, reproduce, fix, or create a PR for it. Covers: checking whether the issue is already resolved, reproducing the bug in the example app, applying the fix, committing on a new branch, and opening a PR linked to the issue."
argument-hint: "[issue-url-or-number]"
---

# Fix GitHub Issue — End-to-end Workflow

## FIRST: check for arguments

**Before doing anything else**, check whether the user supplied an argument (issue URL or number) after the skill name.

If NO argument was provided, output EXACTLY this message and stop — do not proceed further:

```
Usage: /fix-github-issue <issue>

  <issue>  GitHub issue URL or number

Examples:
  /fix-github-issue 40
  /fix-github-issue https://github.com/mduccc/flutter_calendar_week/issues/40
```

If an argument WAS provided, extract the issue number:

```
If $ARGS is a full URL  →  parse the trailing number:
  https://github.com/mduccc/flutter_calendar_week/issues/40  →  ISSUE=40

If $ARGS is just a number  →  use it directly:
  40  →  ISSUE=40
```

Use `ISSUE` as the issue number throughout every step below.
Also set `REPO=mduccc/flutter_calendar_week` (fixed for this project).

---

This skill guides you through the full lifecycle of a GitHub issue for this Flutter package:

1. **Understand** the issue
2. **Check** whether it is already resolved in the codebase
3. **Reproduce** it in the example app
4. **Fix** it
5. **Commit** on a dedicated branch
6. **Open a PR** linked to the issue

---

## Step 1 — Understand the issue

Fetch the issue and all its comments:

```bash
gh issue view $ISSUE --repo $REPO --comments
```

Read carefully:
- What is the reported symptom?
- What steps does the reporter take to trigger it?
- Are there follow-up comments with extra context or alternative reproductions?

---

## Step 2 — Check if it is already resolved

Identify the files most likely to contain the bug (widget state, controller, utility functions). Read them and trace the logic described in the issue. Ask:

- Does the current code still contain the pattern that causes the symptom?
- If the fix is already present, say so clearly and stop.

Key files for this package:
- `lib/src/calendar_week.dart` — `CalendarWeekController` and `CalendarWeek` widget
- `lib/src/date_item.dart` — per-day cell rendering and colour logic
- `lib/src/utils/compare_date.dart` — date equality helper

---

## Step 3 — Reproduce in the example app

### 3a. Launch the example app

```bash
# Find a booted simulator
xcrun simctl list devices available | grep Booted

# Launch
cd example && flutter run -d <device-id> 2>&1 &
sleep 35   # wait for build + launch
```

### 3b. Take a "before" screenshot (correct state)

```bash
xcrun simctl io <device-id> screenshot /tmp/before.png
```

Read the screenshot with the Read tool to confirm the app looks correct.

### 3c. Simulate the bug condition

Because you cannot change the system clock without `sudo`, simulate a stale state by **temporarily modifying the source** to reproduce the exact incorrect behaviour the issue describes.

For example, if the bug is a frozen "today" date, temporarily set:
```dart
// in CalendarWeekController
final DateTime today = DateTime.now().subtract(const Duration(days: 1));
```

Kill and relaunch the app, take an "after" screenshot, then explain clearly what each screenshot shows and why it demonstrates the bug.

### 3d. Revert the simulation change immediately

After taking the screenshot, undo the temporary change before proceeding.

---

## Step 4 — Fix

Apply the minimal correct fix. Do not refactor unrelated code.

After editing:
```bash
flutter analyze lib/
flutter test
```

Both must pass with no new issues before continuing.

---

## Step 5 — Commit on a new branch

Derive a short slug from the issue title (e.g. issue #40 "stale today highlight" → `fix/stale-today-highlight`).

```bash
# Create the fix branch
git checkout -b fix/<short-slug>

# Stage only the changed library files (not the example app unless it needed changes)
git add lib/...

# Commit — reference the issue number in the message
git commit -m "$(cat <<'EOF'
<concise one-line summary> (#$ISSUE)

<One or two sentences explaining WHY the bug existed and what the fix does.>

Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>
EOF
)"
```

Then reset master so the fix lives only on the branch:

```bash
git checkout master
git reset --hard HEAD~1
git checkout fix/<short-slug>
```

---

## Step 6 — Push and open a PR linked to the issue

```bash
git push -u origin fix/<short-slug>

gh pr create \
  --title "<concise title>" \
  --base master \
  --head fix/<short-slug> \
  --body "$(cat <<'EOF'
Closes #$ISSUE

## Problem
<One paragraph explaining what the bug was and why it happened — include the relevant code snippet.>

## Fix
<One paragraph explaining the change — include the fixed code snippet.>

## Testing
- `flutter analyze` — no issues
- `flutter test` — all tests pass
EOF
)"
```

`Closes #$ISSUE` in the PR body tells GitHub to auto-close the issue when the PR is merged.

Return the PR URL to the user.

---

## Checklist

- [ ] Issue fetched and fully understood (including all comments)
- [ ] Verified the bug is NOT already fixed in the codebase
- [ ] Bug reproduced visually in the example app with before/after screenshots
- [ ] Simulation change reverted before applying the real fix
- [ ] `flutter analyze` passes
- [ ] `flutter test` passes
- [ ] Commit is on a dedicated `fix/` branch (not master)
- [ ] PR opened with `Closes #<number>` in the body
- [ ] PR URL returned to the user
