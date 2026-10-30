# Wait for the final MySQL service in CI

PR60 run41139211039/job124349077727 reported MySQL healthy at 22:36:33, then the first historical SQL command failed with ERROR 2002 at 22:36:34. Container logs show the initialization-only temporary mysqld on port 0, followed by “Stopping temporary server”. The original localhost socket health check observed that temporary process, rather than the final service. The historical script was unchanged from green PR59; the new exact endpoint/menu step was skipped, so this failure provides no result for those scenarios.

The health check now explicitly uses TCP to 127.0.0.1. The initialization-only process with networking disabled cannot satisfy that probe. The same disposable container, password, health intervals/retries, SQL scripts and all assertions remain unchanged. This fixes readiness rather than retrying SQL or hiding failures.

Validation before PR: workflow YAML parsing and git diff --check pass. Original job/container timestamps establish the reproduction; automatic CI will verify final readiness and all downstream SQL scenarios. No shared database, production migration, application/framework source, or deployment is changed.
