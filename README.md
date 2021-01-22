# Distributions of permanent income and wealth in the SCF.

Micro and macroeconomic models dealing with the distribution of wealth and its accumulation often need to make assumptions about the initial distribution of wealth, ``permanent income'', or their ratio.
This repository is meant to provide clear and replicable moments of these distributions that can be used by researchers in their calibrations.

# Inputs

This repository's summary statistics are calculated on the Survey of Consumer Finances' Summary Extract files. For replicability, it uses the Summary Files' readily computed
values of income, wealth, age, and education.

# Output: `WealthIncomeStats.csv`

This is the main file that contains the summary statistics that are the purpose of this repository. They are stored as a `.csv` table with the following columns, described by groups:
- Demographic and sample-defining variables: these variables describe the sample on which the summary statistics were computed on. Their values should be read as filters applied
  to the SCF's population before computing the summary statistics.
  - `Educ`: education level. It can take the levels `NoHS` for individuals without a high-school diploma, `HS` for individuals with a high-school diploma but no college degree, and
    `College` for individuals with a college degree. `All` marks rows in which individuals from all educational attainment levels were used.
  - `Age_grp`: age group. I split the sample in 5-year brackets according to their age and this variable indicates which bracket the statistics correspond to. Note that the left
     extreme of brackets is not included, so `(20,25]` corresponds to ages `{21,22,23,24,25}`. `All` marks rows in which all age groups were used.
  - `YEAR`: survey wave of the SCF. It indicates which waves of the SCF were used in calculating the row's statistics. `All` marks rows in which all waves were pooled. **NOTE:**
     when combining multiple waves,  I do not re-weight observations: I continue to use the weight variable as if all observations came from the same wave.
     
 - Summary statistics:
  - `lnPermIncome.mean` and `lnPermIncome.sd`: survey-weighted mean and standard deviation of the natural logarithm of "permanent income", as measured by the variable `norminc`
    in the SCF's summary files. Note that this measure contains, among others, capital gains and pension-fund withdrawals and might therefore substantially differ from the
    popular concept of the "permanent component" of labor income, especially at older ages
    (see [the SCF's website for exact definitions](https://www.federalreserve.gov/econres/scfindex.htm)).
