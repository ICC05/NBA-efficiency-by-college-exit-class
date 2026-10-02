# File guide

For the conceptual overview see [`README.md`](README.md).

## Scripts
| File | What it does |
|---|---|
| `DatasetTesina.R` | Builds the final dataset in five blocks, each downloading tables from saved Stathead queries (`rvest`/`httr`) and saving an intermediate `.RData` file (see below). |
| `AnalisiTesina.R` | Loads `dataset_Tesina.RData`, splits it into RoleG, RoleF and RoleC and, for each subset, runs: 10-fold cross-validation (with vs without `Draft_Year` dummies), pooled OLS, Breusch-Pagan test, HC3 robust errors, Wooldridge test, standard errors clustered by `Draft_Year`, GVIF. |

## Blocks of `DatasetTesina.R`
| Block | Output | What it does |
|---|---|---|
| `dataset_NBA_GPER` | `dataset_NBA_GPER.RData` | NBA season-level data (1987/88–2023/24): computes GPER = PER × MP and the average GPER by career year (plot used to choose the prime window, seasons 4–7). |
| `dataset_NBA` | `dataset_NBA.RData` | First 7 NBA seasons of each player (missing seasons added with zero games): games-weighted average GPER over seasons 1–3, 4–7 and 1–7, and share of games played in each window. |
| `dataset_CollegeTeams` | `dataset_CollegeTeams.RData` | College team results (1986/87–2016/17): builds the CollegePerformance index and the 8 `CollegePerformance_Group` categories. |
| `dataset_College` | `dataset_College.RData` | Statistics of each drafted player in his last college season; converts height to cm and merges the college group. |
| `dataset_Tesina` | `dataset_Tesina.RData` | Merges college and NBA data, builds `OtherStats` and the dependent variable `GPER_Prime` (seasons 4–7, with the penalty for few games played), renames and selects the final variables. |

## Data
| File | Content |
|---|---|
| `dataset_Tesina.RData` | Final dataset used by `AnalisiTesina.R` (one row per player). |
