# pwr
Julia port of `pwr` package in R. This package was originally created by Stephane Champely, from the University of Lyon.

## Installation
To install `pwr`, use the following:

```jldoctest
Pkg.clone("https://github.com/mwsohn/pwr.jl")
```

To use the package, start by `using pwr` in your session.

## Tests for power calculation

All functions in the original R package was ported. For each family of tests,
four functions are additionally available that start with `power`, `samplesize`, `effectsize`, and `alpha` (Type I error). These functions were all exported, but the main tests were not and should be used with `pwr.` in front.

### pwr.AnovaTest

Power calculations for balanced one-way analysis of variance tests

#### Options:

- `k`: number of groups
- `n` = number of observations per group
- `f` = effect size
- `alpha` = Type I error (default: 0.05)
- `power` = 1 - Type II error

#### Functions:

All options listed above must be specified as keyword argments
except for the parameter to be estimated. For example,
for `powerAnovaTest()`, do not specify `power` option:
powerAnovaTest(k=2,n=200,f=.3) will compute power for a sample of 200
in each group with an effect size of .3. For `pwr.AnovaTest()`, exactly
one of the options needs to be set to zero.

- `powerAnovaTest()`
- `samplesizeAnovaTest()`
- `effectsizeAnovaTest()`
- `alphaAnovaTest()`
- `pwr.AnovaTest()`

#### Examples

```jldoctest
julia> p = powerAnovaTest(n=100,k=2,f=.2)
0.8036475048589252

julia> tst = pwr.AnovaTest(n=100,k=2,f=.2,power=0.0)

Balanced one-way analysis of variance power calculation

            k = 2
            n = 100
            f = 0.2
        alpha = 0.05
        power = 0.8036475048589252

NOTE: `n` is the number in each group

julia> plot(tst)
```
### pwr.ChisqTest

Compute power of test or determine parameters to obtain target power (same as power.anova.test)

#### Options:

- `N` = total number of observations
- `w` = effect size
- `df` = degree of freedom (depends of the chosen test)
- `alpha` = Type I error (default: 0.05)
- `power` = 1 - Type II error

#### Functions:

All options listed above need to be specified as keyword argments except for the parameter to be estimated.
For example, for `powerChisqTest()`, do not specify `power` option: powerChisqTest(df=2,N=200,w=.3) will
compute power for a sample of 200 in a table with a degree of freedom 2 with an effect size of .3. For `pwr.ChisqTest()`, exactly one of the options `w`, `N`, `alpha`, and `power` needs to be set to zero.

- `powerChisqTest()`
- `samplesizeChisqTest()`
- `effectsizeChisqTest()`
- `alphaChisqTest()`
- `pwr.ChisqTest()`

#### Examples

```jldoctest
julia> powerChisqTest(w.=0.289,df=(4-1)*(3-1),N=100,alpha=0.05)
0.5518252596952123

julia> alphaChisqTest(w=0.346,df=(2-1)*(3-1),N=140,power=0.8)
0.00321629291888053

julia> tst = pwr.ChisqTest(w=0.1,df=(5-1)*(6-1),power=0.80,alpha=0.05)
Chi-square test power calculation

            w = 0.1
            N = 2097
           df = 20
        alpha = 0.05
        power = 0.8

NOTE: `N` is the number of observations

julia> plot(tst)
```
![Image](plots/chisq.png?raw=true)

### pwr.F2Test

Compute power of test or determine parameters to obtain target power.
This function provides power calculations for the general linear model.

#### Options:

- `u` = degree of freedom for numerator
- `v` = degree of freedom for denominator
- `f2` = effect size
- `alpha` = Type I error (default: 0.05)
- `power` = 1 - Type II error

#### Functions:

All options listed above need to be specified as keyword argments except for the parameter to be estimated.
For `pwr.F2Test()`, exactly one of the options `u`, `v`, `f2`, `alpha`, and `power` needs to be set to zero.

- `powerF2Test()`
- `samplesizeF2Test()`
- `effectsizeF2Test()`
- `alphaF2Test()`
- `pwr.F2Test()`

#### Examples

```jldoctest
julia> pwr.F2Test(u=5,v=89,f2=0.1/(1-0.1),alpha=0.05)
Multiple regression power calculation

            u = 5
            v = 89
           f2 = 0.11111111111111112
        alpha = 0.05
        power = 0.6735857709143758
```

### pwr.NormTest

Compute power for the mean of a normal distribution with known variance

#### Options:

- `d`: effect size (μ - μ₀)
- `n` = number of observations
- `alpha` = Type I error (default: 0.05)
- `power` = 1 - Type II error
- `alternative` = "less" for testing μ < μ₀, "two-sided" for μ = μ₀, and "greater" for μ > μ₀ (default: "two-sided")

#### Functions:

All options listed above need to be specified as keyword argments except for the parameter to be estimated.
For `pwr.NormTest()`, exactly one of the options `d`, `n`, `alpha`, and `power` needs to be set to zero.

- `powerNormTest()`
- `samplesizeNormTest()`
- `effectsizeNormTest()`
- `alphaNormTest()`
- `pwr.NormTest()`

#### Examples

Power at μ = 105 for H₀:μ=100 vs. Hₐ:μ>100 (σ = 15) in a sample of 20 observations
at alpha = 0.05 can be caculated as follows:

```jldoctest
julia> σ = 15.
15.0

julia> c = 100
100

julia> μ = 105.
105.0

julia> d = (μ -c)/σ
0.3333333333333333

julia> t = pwr.NormTest(d=d,n=20,alpha=0.05,alternative="greater")
Mean power calculation for normal distribution with known variance

            n = 20
            d = 0.3333333333333333
        alpha = 0.05
        power = 0.4387490275410111
  alternative = greater
```

### pwr.TTest

Compute power for t-test of means (one sample, two samples and paired samples)

#### Options:

- `d`: effect size
- `n` = number of observations per group
- `alpha` = Type I error (default: 0.05)
- `power` = 1 - Type II error
- `sampletype` = "onesample" for one sample t-test or "twosample" for two sample t-test (default: "onesample")
- `alternative` = "less" for testing μ₁ < μ₂, "two-sided" for μ₁ = μ₂, and "greater" for μ₁ > μ₂ (default: "two-sided")

#### Functions:

All options listed above need to be specified as keyword argments except for the parameter to be estimated.
For example, for `powerTTest()`, do not specify `power` option: powerTTest(k=2,n=200,d=.3) will
compute power for a sample of 200 in each group with an effect size of .3. For `pwr.TTest()`, exactly
one of the options `d`, `n`, `alpha`, and `power` needs to be set to zero.

- `powerTTest()`
- `samplesizeTTest()`
- `effectsizeTTest()`
- `alphaTTest()`
- `pwr.TTest()`

#### Examples

```jldoctest
julia> powerTTest(n=100,d=.3, alternative="two-sided")
0.8439471027376636

julia> samplesizeTTest(d=.3, power = 0.8, alternative="two-sided")
90

julia> tst = pwr.TTest(n=100,d=.3,power=0.0, sampletype = "onesample", alternative="two-sided")
One-sample t-test power calculation

            n = 100
            d = 0.3
        alpha = 0.05
        power = 0.8439471027376636
   sampletype = One-sample
  alternative = two-sided

NOTE: `n` is number in each group

julia> plot(tst)
```

### pwr.T2nTest

Compute power of tests or determine parameters to obtain target power (similar to TTest)

#### Options

- `n1` = Number of observations in the first sample
- `n2` = Number of observations in the second sample
- `d` = Effect size
- `alpha` = Type I error
- `power` = Power of test (1 minus Type II error)
- `alternative` = "less" for Hₐ:μ₁ < μ₂, "two-sided" for Hₐ:μ₁ = μ₂, and "greater" for Hₐ:μ₁ > μ₂ (default: "two-sided")

#### Functions:

All options listed above need to be specified as keyword argments except for the parameter to be estimated.
For example, for `powerTTest()`, do not specify `power` option: powerTTest(k=2,n=200,d=.3) will
compute power for a sample of 200 in each group with an effect size of .3. For `pwr.TTest()`, exactly
one of the options `d`, `n`, `alpha`, and `power` needs to be set to zero.

- `powerTTest()`
- `samplesizeTTest()`
- `effectsizeTTest()`
- `alphaTTest()`
- `pwr.TTest()`

#### Examples

```jldoctest
julia> powerT2nTest(n1=100,n2=150,d=.3, alternative="two-sided")
0.6386472954918861

julia> effectsizeT2nTest(n1=100,n2=150,power = 0.8,alternative="two-sided")
0.3630907608326113

julia> pwr.T2nTest(n1=100,n2 = 0,d=.3,power=0.0, alternative="two-sided")
T-test power calculation

           n1 = 100
           n2 = 695
            d = 0.3
        alpha = 0.05
        power = 0.8
  alternative = two-sided
```
