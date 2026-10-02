# Impact of College Exit Class on NBA Career Efficiency

R code for the construction of a player-level dataset of NBA players drafted from NCAA Division I Men's Basketball (1987–2017) and for the econometric analysis of how the number of college seasons played before the draft (**Class**) relates to NBA efficiency in the prime of a player's career.

The code accompanies the internal thesis *Impact of College Exit Class on NBA Career Efficiency* (I. Cardosi Carrara, Sant'Anna School of Advanced Studies, Department of Economics, a.y. 2023/24, supervised by Prof. Angela Parenti).

---

## 1. Research question

When scouts evaluate a college prospect, they mostly look at the statistics of the player's **last college season**. But a player who stays in college for three or four years has had more time to develop than a "one-and-done" freshman, so the same last-season numbers may not mean the same thing.

The study asks: **controlling for last-season college statistics, height and college strength, do players who left college later (Sophomore, Junior, Senior) reach a lower NBA efficiency than those who left after one year (Freshman)?**

- **Variable of interest**: `Class`, the college class at the time of the draft: Freshman (FR, 1 season, reference category), Sophomore (SO, 2), Junior (JR, 3), Senior (SR, 4).
- **Hypothesis**: the differential effects of SO, JR and SR are negative, and grow in magnitude and significance with the number of extra years in college.

## 2. Data

All raw data come from the [Stathead](https://stathead.com) databases (Sports Reference), downloaded through saved Stathead queries.

The final dataset `dataset_Tesina.RData` contains **one observation per player** (1,171 players drafted between 1987 and 2017), identified by `Player` and `Draft_Year`.

### Dependent variable: `GPER_Prime`

- **PER** (Player Efficiency Rating, Hollinger 2005) measures per-minute efficiency, adjusted for team pace and normalized to a league average of 15 every season.
- **GPER = PER × minutes per game**: a per-game efficiency index that also rewards playing time.
- Average GPER by career year rises during the first three seasons, peaks between the 4th and 7th season, then declines. The prime window is therefore set to **seasons 4–7**.
- **`GPER_Prime`** is the games-weighted average GPER over seasons 4–7. It is reduced by 25%, 50%, 75% or 100% when the player appeared in less than 20%, 15%, 10% or 5% of the available games in that window. Missing seasons count as zero games.

### College strength: `CollegePerformance_Group`

For each of the 299 Division I colleges, over 1986/87–2016/17:

CollegePerformance = 0.25 · NonConfWin% + 0.75 · NCAAWin% · NCAAGames (normalized)

Here NonConfWin% is the win rate in non-conference regular-season games, NCAAWin% the win rate in the NCAA tournament and NCAAGames the number of tournament games played. The index is rescaled to [0, 1] and cut into **8 groups** (Group1 = strongest, e.g. Duke, Kansas, North Carolina, Kentucky; Group8 = weakest, reference category).

### Controls (last college season)

| Variable | Meaning |
|---|---|
| `Height` | Height in cm |
| `TwoA`, `Two_perc` | 2-point attempts per game and percentage |
| `ThreeA`, `Three_perc` | 3-point attempts per game and percentage |
| `FTA`, `FT_perc` | Free-throw attempts per game and percentage |
| `AST` | Assists per game |
| `TRB` | Total rebounds per game |
| `OtherStats` | Steals + blocks − turnovers per game |

## 3. Method

The sample is split by position (`Pos`) into three subsets, analysed separately:
- **RoleG** (guards): G, G-F;
- **RoleF** (forwards): G-F, F, F-G, F-C;
- **RoleC** (centers): F-C, C-F, C.

Hybrid positions belong to more than one subset.

For each subset:
1. **Model selection**: 10-fold cross-validation compares pooled OLS with and without `Draft_Year` dummies. The model without year dummies has the lower RMSE in all three cases.
2. **Model**:

   GPER_Prime = β₀ + β₁·Class + β₂·CollegePerformance_Group + β₃·Height + β₄·Two_perc + β₅·Three_perc + β₆·TwoA + β₇·ThreeA + β₈·FT_perc + β₉·FTA + β₁₀·AST + β₁₁·TRB + β₁₂·OtherStats + ε

3. **Diagnostics**:
   - studentized Breusch-Pagan test (heteroskedasticity);
   - Wooldridge test for serial correlation;
   - Generalized Variance Inflation Factor (multicollinearity).
4. **Inference**: standard errors clustered by `Draft_Year`, robust to heteroskedasticity and within-year dependence.

## 4. Results (from the thesis)

Effect of `Class` on `GPER_Prime`, relative to Freshman (clustered standard errors):

| | RoleG (guards) | RoleF (forwards) | RoleC (centers) |
|---|---|---|---|
| Sophomore | −123.1 ** | −113.2 *** | −86.2 (n.s.) |
| Junior | −148.4 *** | −181.1 *** | −210.8 *** |
| Senior | −265.0 *** | −250.9 *** | −261.5 *** |
| R² | 0.19 | 0.29 | 0.43 |

Significance: *** p < 0.001, ** p < 0.01. For reference, a GPER around 270–400 corresponds to a slightly above-average NBA player and 500–675 to a borderline All-Star.

- **The hypothesis is broadly confirmed**: for all three roles the Junior and Senior effects are large, negative and highly significant, and the effects grow with the number of extra college seasons.
- **Senior**: the penalty is very similar across roles, about −250.
- **Junior**: the penalty is about −150 for guards and forwards and larger for centers (about −210).
- **Sophomore**: the effect is significant for guards and forwards but not for centers.
- **Interpretation**: last-season college statistics should not be evaluated independently of the number of seasons played, because players who stay longer show a systematic growth pattern that does not translate into higher NBA efficiency.
- **Diagnostics**: Breusch-Pagan rejects homoskedasticity in all subsets, which motivates the clustered errors. All GVIF^(1/(2·Df)) values are below 2, so multicollinearity is not a concern.

## 5. How to run

Requirements: R with the packages `rvest`, `httr`, `dplyr`, `tidyr`, `ggplot2`, `fastDummies` (dataset construction) and `caret`, `car`, `lmtest`, `sandwich`, `plm`, `clubSandwich`, `stargazer`, `strucchange`, `wooldridge`, `tseries` (analysis).

1. **Dataset construction** (`DatasetTesina.R`): downloads the tables from saved Stathead queries and builds `dataset_Tesina.RData`. The Stathead links require an active Stathead subscription.
2. **Analysis** (`AnalisiTesina.R`): loads `dataset_Tesina.RData` and runs the analysis for the three roles. The dataset is included, so this step can be run directly.

Both scripts start with `setwd(...)` pointing to a local folder: change it to the folder of the repository before running.

A description of every file is in [`CODE.md`](CODE.md).

## Main references
- Hollinger, J. (2005). *Pro Basketball Forecast*. Potomac Books.
- Stathead (2024). https://stathead.com
