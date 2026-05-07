# MethOnt — Methodology Ontology (Core)

**MethOnt** is a reusable OWL ontology that provides a shared vocabulary for describing quantitative methodologies — structured sets of applicability conditions, constraints, symbolic variables, and ordered equation steps that collectively produce a measurable indicator value.

It is designed as a **core library**: domain-specific method catalogues (e.g., CDM, GS, Verra) import MethOnt and extend it with their own instances, keeping the vocabulary clean and interoperable across standards bodies.

---

## Purpose

Many sustainability, carbon-accounting, and impact-measurement frameworks define *methodologies* — step-by-step calculation procedures tied to specific activity types, geographies, and data-quality requirements. MethOnt captures this shared structure in a single, standards-aligned ontology so that:

- Methodology definitions can be **machine-readable** and **linked-data compatible**.
- Individual method catalogues remain modular and independently versioned.
- Cross-standard queries (e.g., "find all large-scale methodologies applicable to cookstoves in Sub-Saharan Africa") become straightforward SPARQL queries.

---

## Namespace

| Prefix | IRI |
|--------|-----|
| `meth:` | `http://independentimpact.org/methodology/` |

Current ontology IRI: `http://independentimpact.org/methont/methont.ttl/1.1.0`

---

## Ontology Imports

MethOnt builds on the following standard vocabularies:

| Ontology | Role |
|----------|------|
| [IndicatorOntology (`ind:`)](http://independentimpact.org/indicator-owl/) | Defines `Indicator`, `Symbol`, `IndicatorFormula`, and `hasUnit` — the targets that methodologies produce |
| [AIAO (`aiao:`)](http://w3id.org/aiao) | Activity taxonomy used to scope methodology applicability |
| [PROV-O (`prov:`)](http://www.w3.org/ns/prov-o) | `prov:Plan` parent class for `Methodology`; `prov:Location` for territorial scope |
| [SHACL (`sh:`)](http://www.w3.org/ns/shacl) | `sh:NodeShape` parent for constraint classes; validation shape linking |
| [QUDT (`qudt:` / `unit:`)](http://qudt.org/schema/qudt/) | Unit-of-measure vocabulary attached to variables |

---

## Core Vocabulary

### Classes

| Class | Description |
|-------|-------------|
| `meth:Methodology` | A structured set of applicability conditions, constraints, and ordered equations that produces a quantified indicator value. Subclass of `prov:Plan`. |
| `meth:ApplicabilityCondition` | Contextual requirements (activity, geography, temporal scope) that must hold before a methodology may be executed. |
| `meth:SemanticConstraint` | Qualitative rule restricting applicability (e.g., facility classification, compliance status). Subclass of `sh:NodeShape`. |
| `meth:VariableConstraint` | Quantitative bound or validation rule applied to a measured or computed variable. Subclass of `sh:NodeShape`. |
| `meth:EquationStep` | An ordered formula that computes one variable from one or more inputs; steps chain together until the indicator is quantified. Subclass of `ind:IndicatorFormula`. |
| `meth:Variable` | A symbolic quantity used in methodology equations. |
| `meth:MeasuredVariable` | Variable whose value is obtained from monitoring, sampling, or metering. |
| `meth:DerivedVariable` | Variable that functions as a symbolic placeholder, resolved from constants or derived computations. |
| `meth:ValueRole` | Role that a symbol plays within a methodology (measured input or calculated output). |
| `meth:MethodologyFamily` | A grouping of methodology versions sharing the same method-code lineage (e.g., ACM0001). |
| `meth:MonitoringRequirement` | How variables must be measured, sampled, or verified during implementation. |
| `meth:DataQualityRequirement` | Completeness, calibration, or QA/QC thresholds for accepted data. |
| `meth:MonitoringFrequency` | Required frequency of monitoring observations. |
| `meth:MinimumDataCoverage` | Minimum data coverage threshold for a monitoring requirement. |
| `meth:Constant` | A fixed coefficient used by a methodology or equation step (e.g., a default GWP value). |
| `meth:UncertaintyModel` | Description of uncertainty treatment for a methodology, step, or parameter. |

### Key Object Properties

| Property | Domain → Range | Description |
|----------|---------------|-------------|
| `meth:forIndicator` | `Methodology → impact:Indicator` | Links a methodology to the indicator it produces. |
| `meth:hasMethodology` | `impact:Indicator → Methodology` | Inverse of `forIndicator`; enumerates compatible methodologies from an indicator. |
| `meth:hasApplicability` | `Methodology → ApplicabilityCondition` | Attaches applicability scope conditions. |
| `meth:hasSemanticConstraint` | `Methodology → SemanticConstraint` | Attaches qualitative rules. |
| `meth:hasVariableConstraint` | `Methodology/EquationStep → VariableConstraint` | Attaches quantitative bounds. |
| `meth:hasEquationStep` | `Methodology → EquationStep` | Attaches ordered computation steps. |
| `meth:nextStep` | `EquationStep → EquationStep` | Creates a linear chain of steps; the last step produces the indicator value. |
| `meth:dependsOnStep` | `EquationStep → EquationStep` | Declares a DAG-style dependency between steps. |
| `meth:computes` | `EquationStep → Variable` | Output symbol produced by a step. |
| `ind:usesSymbol` | `EquationStep → Variable` | Input symbols consumed by a step. |
| `meth:hasScaleClassification` | `Methodology → skos:Concept` | Tags the methodology as large-scale or small-scale. |
| `meth:hasActivityClassification` | `Methodology → skos:Concept/aiao:Activity` | Tags the methodology with an applicable activity type. |
| `meth:appliesToSector` | `Methodology → skos:Concept` | Sector applicability tag. |
| `meth:supersedes` / `meth:supersededBy` | `Methodology → Methodology` | Version lineage links. |
| `meth:hasMonitoringRequirement` | `Methodology → MonitoringRequirement` | Attaches monitoring obligations. |
| `meth:usesConstant` | `Methodology/EquationStep → Constant` | Attaches fixed coefficients. |
| `meth:hasUncertaintyModel` | `Methodology/EquationStep/Constant → UncertaintyModel` | Attaches uncertainty descriptions. |
| `meth:implementedBy` | `Methodology → prov:SoftwareAgent/prov:Plan` | Links to a software or process implementation. |

### Key Datatype Properties

| Property | Domain | Range | Description |
|----------|--------|-------|-------------|
| `meth:validFrom` | `ApplicabilityCondition`, `Methodology` | `xsd:date` | Start of temporal applicability. |
| `meth:validThrough` | `ApplicabilityCondition`, `Methodology` | `xsd:date` | End of temporal applicability. |
| `meth:sequenceNumber` | `EquationStep` | `xsd:positiveInteger` | Explicit ordering index for equation steps. |
| `meth:formulaId` | `EquationStep` | `xsd:string` | Human-readable formula identifier (e.g., "Eq.3a"). |
| `meth:methodCode` | `MethodologyFamily`, `Methodology` | `xsd:string` | Standard method code (e.g., "ACM0001"). |
| `meth:hasVersion` | `Methodology` | `xsd:string` | Version string (e.g., "v8.0"). |
| `meth:minValue` / `meth:maxValue` | `VariableConstraint` | `xsd:decimal` | Numeric bounds for variable validation. |
| `meth:defaultValue` | `Constant` | `xsd:decimal` | Default numeric value of a constant. |
| `meth:uncertaintyValue` | `UncertaintyModel` | `xsd:decimal` | Numeric uncertainty magnitude. |
| `meth:constraintNote` | `SemanticConstraint`, `VariableConstraint` | `xsd:string` | Human-readable description of the constraint. |

---

## Repository Layout

```
MethOnt/
├── methont.ttl   # Source ontology (authoritative)
├── methont.owl   # Generated RDF/XML
├── methont.jsonld # Generated JSON-LD
├── docs/methont.html # Generated human-readable documentation
├── convert.py    # Conversion/generation script
└── README.md     # This file
```

Source-specific method catalogues (e.g., CDM, GS, Verra) remain in the `SKOS_CDM_Methodologies` repository (and equivalent programme-specific repos) and should import this core ontology by URL.

---

## Usage

### Importing MethOnt into your ontology

Reference the versioned ontology IRI in your Turtle file:

```turtle
@prefix owl: <http://www.w3.org/2002/07/owl#> .

<your-ontology-iri> a owl:Ontology ;
  owl:imports <http://independentimpact.org/methont/methont.ttl/1.1.0> .
```

### Declaring a methodology instance

```turtle
@prefix meth: <http://independentimpact.org/methodology/> .
@prefix ex:   <http://example.org/methods/> .
@prefix ind:  <http://independentimpact.org/indicator-owl/> .

ex:ACM0001-v8 a meth:Methodology ;
  meth:methodCode    "ACM0001" ;
  meth:hasVersion    "v8.0" ;
  meth:validFrom     "2022-01-01"^^xsd:date ;
  meth:hasScaleClassification ex:LargeScale ;
  meth:forIndicator  ex:EmissionReductions .
```

### Generating OWL, JSON-LD, and HTML from TTL

Run from the repository root:

```bash
python convert.py methont.ttl
```

This generates:
- `methont.owl` (RDF/XML)
- `methont.jsonld` (JSON-LD)
- `docs/methont.html` (documentation page)

---

## Versioning

| Version | IRI suffix | Date |
|---------|-----------|------|
| 1.1.0 | `/methont.ttl/1.1.0` | 2026-04-08 |
| 1.0.0 | `/methont.ttl/1.0.0` | 2026-02-12 |

The ontology follows semantic versioning. Breaking changes increment the major version; new classes/properties increment the minor version.

---

## License

[MIT](LICENSE) © 2026 Nova Institute
