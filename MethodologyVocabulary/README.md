# MethodologyVocabulary

SKOS concept vocabularies for methodology metadata and annotation.

## Purpose

This module folder provides controlled concept schemes used by MethOnt properties and methodology validation workflows.

## Namespace

- `meth:` `http://independentimpact.org/methodology/`

## Files

- `context.ttl` - top-level bundle ontology
- `methodology-concepts.ttl` - imports all concept modules
- `concepts/activity-classifications.ttl`
- `concepts/scale-classifications.ttl`
- `concepts/value-roles.ttl`
- `concepts/uncertainty-types.ttl`
- `concepts/monitoring-requirements.ttl`
- `concepts/data-quality-requirements.ttl`
- `concepts/math-notations.ttl`

## Imports

`context.ttl` imports:
- `methodology-concepts.ttl`

`methodology-concepts.ttl` imports:
- `concepts/value-roles.ttl`
- `concepts/monitoring-requirements.ttl`
- `concepts/data-quality-requirements.ttl`
- `concepts/uncertainty-types.ttl`
- `concepts/math-notations.ttl`
- `concepts/activity-classifications.ttl`
- `concepts/scale-classifications.ttl`

## Position in Stack

- `methodologyOntology` (repo root) = core classes/properties (`methont.ttl`)
- `MethodologyValidation/` (sibling folder) = SHACL and constraint schema
- `MethodologyVocabulary/` (this folder) = reusable SKOS concepts


## Validation

```powershell
.\scripts\validate_ttl.ps1
```

## Release Checklist

1. Run .\scripts\validate_ttl.ps1.
2. Verify methodology-concepts.ttl imports all intended concept files.
3. Confirm concept schemes and labels are up to date.
4. Commit and tag release.

