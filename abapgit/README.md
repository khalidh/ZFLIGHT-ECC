# abapGit import folder

This folder contains serialized RAP objects generated from `src/btp_rap` so abapGit can detect ABAP repository objects.

The repository root `.abapgit.xml` sets `STARTING_FOLDER` to `/abapgit/` and `FOLDER_LOGIC` to `FULL`.

Import order is still governed by activation dependencies: DDLS tables, CDS interface/projection, behavior definitions, services, metadata, DCL and classes.
