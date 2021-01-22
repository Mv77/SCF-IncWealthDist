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
      
    - `lnWealth.mean` and `lnWealth.sd`: survey-weighted mean and standard deviation of the natural logarithm of "wealth", as measured by the variable `networth` in the SCF's
       summary files. Find the definition of `networth` in [the SCF's website](https://www.federalreserve.gov/econres/scfindex.htm).
       
    - `lnPermIncome.mean` and `lnPermIncome.sd`: survey-weighted mean and standard deviation of the natural logarithm of the ratio of wealth to permanent income, as measured by           
      `networth/norminc`.
      
 - Weights, observation, and base year:
    - `obs`: counts the number of observations in from the SCF that go into computing the statistics in each row. Note that the SCF creates five "imputation replicates" for
      every individual that is actually surveyed. Therefore the actual number of individuals that go into computing each row should be approximately `obs/5`.
    - `w.obs`: is the sum of survey weights of the observations that are used for computing the summary statistics in each row.
    - `BASE_YR`: indicates the base year used for expressing dollar quantities in the SCF summary files used for computing the summary statistics. The ratio of wealth to permanent
      income won't be affected by inflation adjustments, but permanent income and wealth (independently) will be.
