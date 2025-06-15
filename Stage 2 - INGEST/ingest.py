import glob
import pandas as pd
from sqlalchemy import create_engine

parquet_dir = "./data/preprocessed/20250616-Customer-Snapshot/"

parquet_files = glob.glob(parquet_dir + "*.parquet")
df = pd.concat([pd.read_parquet(f) for f in parquet_files], ignore_index=True)


engine = create_engine('postgresql+psycopg2://gfgvnadmin:gfgvnadminpwd@localhost:5432/gfg')

df.to_sql('customer_snapshot', engine, if_exists='replace', index=False)
