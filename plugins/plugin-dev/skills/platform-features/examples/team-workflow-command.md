# Team Workflow Command Example

Example command that creates a team for parallel code review.

## Command File: commands/parallel-review.md

```markdown
---
description: Parallel code review using agent teams
argument-hint: [files-or-directory]
allowed-tools: ["TeamCreate", "SendMessage", "TaskCreate", "TaskList", "TaskUpdate", "TaskGet", "Read", "Glob", "Grep"]
---

# Parallel Code Review

Create a review team to analyze code in parallel.

## Steps

1. **Discover files to review:**
   Use Glob to find files matching: $ARGUMENTS
   If no argument provided, find recently modified files.

2. **Create review team:**
   Use TeamCreate to create a "code-review" team.

3. **Create tasks:**
   For each file or group of files, create a TaskCreate with:
   - subject: "Review [filename]"
   - description: "Review for quality, security, and best practices"
   - activeForm: "Reviewing [filename]"

4. **Spawn reviewers:**
   Launch 2-3 general-purpose agents as team members.
   Assign tasks to each reviewer.

5. **Coordinate:**
   Monitor TaskList for completion.
   Collect results from each reviewer.

6. **Generate report:**
   Compile findings into a unified review report.
   Include file-level and project-level findings.

7. **Cleanup:**
   Send shutdown requests to team members.
   Delete team when complete.
```

## Design Notes

- Uses TeamCreate for parallel work coordination
- Tasks track individual file reviews
- Each reviewer operates independently
- Results aggregated by the command
- Team cleaned up after completion
