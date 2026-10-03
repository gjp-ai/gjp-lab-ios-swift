# 0002: One flat folder per feature and per app area

Status: Accepted, 2026-10-03

## Context

Features used `data/` and `model/` subfolders, and `app/navigation/` used `sidebar/` and `catalog/` subfolders. Most of those folders held a single file, so readers opened several folders to follow one small feature, and every move touched many doc links.

## Decision

Each feature (`features/<category>/<feature>/`) and each app area (`app/startup/`, `app/navigation/`) is one flat folder holding its screens, controllers, repositories, models, and resources. Do not create subfolders by file type. Category folders (`features/<category>/`) hold only feature folders.

## Consequences

- One folder shows everything a feature needs, which suits a learning lab.
- `doc/specs/` mirrors the same flat folders; several screens in one area share a folder and are told apart by file name prefix (for example `splash_requirement.md`, `maintenance_requirement.md`).
- If a feature grows large, split it by sub-feature (for example `urlsession/history/`), not by file type.
