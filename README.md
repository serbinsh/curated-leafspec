---
title: Spectra and trait data processing
author: Alexey Shiklomanov
---

# Requirements
SQLite3
 - Install on a mac:
	sudo port install sqlite3 (using MacPorts)
 	brew install sqlite3 (brew)	

devtools::install_github("ashiklom/dbhelpers")

# Sample metadata
    - `samplename` -- Sample identifier; usually project-specific
    - `datacode` -- Formerly `RawSpecies`; data-specific species ID, to be matched via `species_dict`
    - `projectcode` -- Project code, matching projects table
    - `sitecode` and `plotcode` -- of the form `project.site.plot`
    - `year` -- Year of collection (preferably extract from `collectiondate`)
    - `samplecode` -- Unique identifier; `project|samplename|year`

# Spectra metadata
    - `sampleprep` -- 

