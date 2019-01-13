# iem2parquet

The [Iowa Environmental Mesonet](http://mesonet.agron.iastate.edu/) archives automated weather
sensor data from stations around the world. They take raw data, published in the standard
[METAR](https://en.wikipedia.org/wiki/METAR) format, do minimal processing and expose it
via a web service.

The web service is a bit pokey and exposes the data as a TSV. These scripts automate
the retrieval of data and conversion to a Parquet file, suitable for further processing
with a big data tool of your choice (or, y'know, [SQLite](https://github.com/cldellow/sqlite-parquet-vtable)).

If you use this, please be considerate of the remote server's capacity.

## Prerequisites

This tool depends on the [`csv2parquet`](https://github.com/cldellow/csv2parquet) package. Install it via:

```
pip install pyarrow csv2parquet
```

## Usage

```
# Download TSV for a period of time.
./fetch CYKF 2018-1-1 2018-1-31 > ykf.tsv

# Convert to Parquet file.
./pq ykf.tsv

# Convert to Parquet file, retain the raw METAR field.
INCLUDE_RAW_METAR=1 ./pq ykf.tsv
```

## Space savings

This table compares the uncompressed TSV size vs the Parquet size for my hometown's
data.

| Duration | TSV size   | Parquet size (incl METAR / excl METAR) | Size decrease |
|----------|------------|----------------------------------------|---------------|
| 1 day    | 15,821     | 9,641 / 7,714                          | 39.1% / 51.2% |
| 1 month  | 331,242    | 54,080 / 25,067                        | 83.7% / 92.4% |
| 1 year   | 3,686,065  | 496,247 / 171,390                      | 86.5% / 95.4% |
| 1 decade | 37,528,193 | 4,768,956 / 1,580,540                  | 87.3% / 95.8% |

## Useful Links

- [CSV of stations](https://mesonet.agron.iastate.edu/sites/networks.php?special=allasos&format=csv&nohtml)
- [Field descriptions](http://mesonet.agron.iastate.edu/request/download.phtml) (scroll to bottom)


