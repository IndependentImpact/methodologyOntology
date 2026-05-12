# MethodologyValidation

Validation and constraint module for the methodology ontology ecosystem.

## Purpose

This module folder contains reusable validation artifacts and constraint packaging terms that extend the MethOnt core model.

- SHACL node shapes for generic methodology quality checks
- Constraint profile schema for grouping and reusing constraint sets

## Namespace

- `meth:` `http://independentimpact.org/methodology/`

## Files

- `context.ttl` - bundle ontology importing this module
- `constraints/constraint-schema.ttl` - constraint profile classes/properties
- `shapes/methodology-generic-shapes.ttl` - generic SHACL shapes

## Imports

`context.ttl` imports:
- `constraints/constraint-schema.ttl`
- `shapes/methodology-generic-shapes.ttl`

`constraint-schema.ttl` imports:
- `http://independentimpact.org/methont/methont.ttl`

## Position in Stack

- `methodologyOntology` (repo root) = core semantics (`methont.ttl`)
- `MethodologyValidation/` (this folder) = constraints and SHACL validation
- `MethodologyVocabulary/` (sibling folder) = SKOS concept vocabularies


## Validation

```powershell
.\scripts\validate_ttl.ps1
```

## Release Checklist

1. Run .\scripts\validate_ttl.ps1.
2. Verify context.ttl bundle imports.
3. Validate updated SHACL/constraint logic against sample data.
4. Commit and tag release.

