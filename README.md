# Remains2LifeTable
This is a script for converting skeletal remains w/ age estimates into an extrapolated model life table. The results are used by Pax Sapientica for the Yayoi period agent-based simulation. It primarily uses two packages: mortAAR and DemoTools. 

The current configuration makes life tables for each sex and separates skeletal remains by group (i.e. population). It allows for the input of infant & child mortality parameters, which override skeletal data. Current child mortality settings are based on Volk & Atkinson (2013)

### Pax Sapientica 
(https://github.com/AsPJT/PAX_SAPIENTICA)

### MortAAR
(https://github.com/ISAAKiel/mortAAR)

### DemoTools
Riffe T, Aburto JM, Alexander M,Fennell S, Kashnitsky I, Pascariu M and Gerland P. (2019). DemoTools: An R package of tools for aggregate demographic analysis. URL: https://github.com/timriffe/DemoTools/

### Reference for Child Mortality Rate (CMR)
Volk, A. A., & Atkinson, J. A. (2013). Infant and child death in the human environment of evolutionary adaptation. Evolution and Human Behavior, 34(3), 182–192. https://doi.org/10.1016/j.evolhumbehav.2012.11.007

## Data
The current configuration makes life tables from Jomon and Yayoi period skeletal remains. The data source is Kyushu University's skeletal remains database (http://db.museum.kyushu-u.ac.jp/anthropology/)

Input data in csv format (input.csv), and adjust the script to suit your needs. I recommend changing the name of the output file to represent your CMR assumptions (e.g. life-table-yayoi-CMR45).

### Age category classification
Below are the assumptions that were made for age categories in the data set. All data modification was done out of script

|年齢 |年齢1|年齢2|name        |
|---|---|---|------------|
|乳児 |0  |1  |infant      |
|幼児 |0  |5  |toddler     |
|小児 |5  |10 |child       |
|若年 |10 |20 |adolescent  |
|成年 |20 |40 |young_adult |
|熟年 |40 |60 |middle_adult|
|老年 |60 |80 |old_adult   |
|未成人|5  |20 |juvenile    |
|成人 |20 |60 |adult       |


### Input Format
ID,site,group,sex,from,to,from_class,to_class
(* = required)

ID = ID of skeletal remains
Site = Site where the remains are from
group = population (culture)*
sex = m (male), f (female), or x (unknown)*
from = age estimate lower bound*
to = age estimate, upper bound*
from_class = from age class (e.g. at a minimum, an infant)
to_class = from age class (e.g. at a maximum, a child)
