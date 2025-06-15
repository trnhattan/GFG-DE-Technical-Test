# Stage 2 : INGEST

For demonstration purposes and easy implementation, PostgreSQL has been utilized as the primary database system, and CloudBeaver serves as the interactive user interface for executing and visualizing SQL queries. This choice simplifies setup and clearly illustrates query results within the scope of this technical test.

## 1. Start
- `docker compose up` the [`docker-compose.yaml`](docker-compose.yaml) file
    - For ease of re-implementation, I has put authorization within `yaml` file. 
- Establish connection to PostgreSQL in CloudBeaver, with:
    - Host: postgres:5432
    - Database: gfg
- Create table `customer_snapshot` with `DDL.sql`
## 2. Ingest data
- Requirements:
    - Python3
    - Dependencies: `pandas`, `pyarrow`, `sqlalchemy`, `psycopg2-binary`
- Execute:
    - `python ./src/ingest.py`
