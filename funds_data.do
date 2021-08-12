clear all
set more off

cd "C:\Users\toral\Documents\Spring 2021\676\Research Paper\data" //set working directory

import delimited "C:\Users\toral\Documents\Spring 2021\676\Research Paper\data\2017-climate-investment-funds--scaling-up-renewable-energy-program-srep-results-data.csv" //import delimited (CSV) file into stata

log using funds_data_results.log, replace

*******************************************************************************
//drop unused variables
drop publicprivate gridconnection mdb lifetime womentargetimprovedenergyaccess mentargetimprovedenergyaccess peopletargetimprovedenergyaccess businessestargetimprovedenergyac communityservicestargetimprovede womenactualimprovedenergyaccessl menactualimprovedenergyaccesslat peopleactualimprovedenergyaccess businessesactualimprovedenergyac communityservicesactualimprovede womencumulativeimprovedenergyacc mencumulativeimprovedenergyacces peoplecumulativeimprovedenergyac businessescumulativeimprovedener communityservicescumulativeimpro cumulativeghgemissionsreducedavo cumulativecofinancingusm cumulativecofinancinggovernmentu cumulativecofinancingprivatesect cumulativecofinancingmdbsusm cumulativecofinancingbilateralsu cumulativecofinancingothersusm cumulativeannualelectricityoutpu

*******************************************************************************
//rename variables pertaining to output and emissions 
ren reportingyear year //year that the project was initially reported 
ren actualannualelectricityoutputlat actual_output //acutal electricity output
ren actualghgemissionsreducedavoided actual_ghg //actual gpg emissions avoided
ren installedcapacitymw capacity //capacity of installed project

ren targetannualelectricityoutputmwh target_output // target electricity output
ren annualtargetghgemissionsreduceda target_ghg // target ghg emission avoided
ren lifetimetargetghgemissionsreduce life_target_ghg //lifetime target ghg emissions reduced/avoided (for the lifetime of the project)

//Variables pertaining to funding 
ren srepfundingusm SREP_fund //SREP funding from the Climate Investment Funds
ren targetcofinancingusm target_cf //total target co-financing goal
ren targetcofinancinggovernmentusm target_gov_cf //target co-financing funds from governments 
ren targetcofinancingprivatesectorus target_private_cf //target co-financing funds from the private sector 
ren targetcofinancingmdbsusm target_mdb_cf //target co-financing funds from multilateral development banks
ren targetcofinancingbilateralsusm target_bilateral_cf //target co-financing funds from bilateral agencies
ren targetcofinancingothersusm target_other_cf //target co-financing funds from other sources

ren actualcofinancinglatestyearusm actual_cf //actual co-financing from the latest year
ren actualcofinancinggovernmentlates actual_gov_cf //actual co-financing from governments in the latest year
ren actualcofinancingprivatesectorla actual_private_cf //actual co-financing from the private sector in the latest year
ren actualcofinancingmdbslatestyearu actual_mdb_cf //actual co-financing from multilateral development banks in the latest year
ren actualcofinancingbilateralslates actual_bilateral_cf //actual co-financing from bilateral agencies in the latest year
ren actualcofinancingotherslatestyea actual_other_cf //actual co-financing from other sources in the latest year 

*******************************************************************************
// Data Visualization
//general variables 
histogram year, width(1) frequency fcolor(eltgreen) lcolor(black) addlabel ///
xlabel(2014 2015 2016 2017 2018) ytitle("Number of Projects") ///
title("SREP Projects by Year") ///
name(G1, replace)
by region, sort : sum SREP_fund

by region, sort : tab technology

//output and emissions variables 
sum actual_output
histogram actual_output, width(2000) frequency fcolor(eltgreen) lcolor(black) ///
addlabel xlabel(#8) xtitle("Actual Annual Energy Output (MWh)") ///
ytitle("Number of Projects") title("Annual Energy Output") name(E1, replace)

histogram actual_output if actual_output!=0, width(2000) frequency fcolor(eltgreen) ///
lcolor(black) addlabel xlabel(#8) xtitle("Actual Annual Energy Output (MWh)") ///
ytitle("Number of Projects") title("Annual (Non-Zero) Energy Output") ///
name(E1_non0, replace)

sum actual_ghg
histogram actual_ghg, bin(5) frequency fcolor(eltgreen) lcolor(black) ///
addlabel xlabel(#8) xtitle("GHG Emissions Reduced (tons of CO2 equivalent)") ///
ytitle("Number of Projects") title("Annual GHG Emissions Reduced") name(E2, replace)

histogram actual_ghg if actual_ghg!=0, bin(10) frequency fcolor(eltgreen) ///
lcolor(black) addlabel xlabel(#8) xtitle("GHG Emissions Reduced (tons of CO2 equivalent)") ///
ytitle("Number of Projects") title("Annual (Non-Zero) GHG Emissions Reduced") ///
name(E2_non0, replace)

sum target_output
histogram target_output, bin(10) frequency fcolor(eltgreen) lcolor(black) ///
addlabel xlabel(#8) xtitle("Actual Annual Energy Output (MWh)") ///
ytitle("Number of Projects") title("Target Annual Energy Output") name(E3, replace)

sum target_ghg
histogram target_ghg, bin(6) frequency fcolor(eltgreen) ///
lcolor(black) addlabel xlabel(#8) xtitle("GHG Emissions Reduced (tons of CO2 equivalent)") ///
ytitle("Number of Projects") title("Target Annual GHG Emissions Reduced") ///
name(E4, replace)

//funding variables
sum SREP_fund
histogram SREP_fund, bin(10) frequency fcolor(eltgreen) ///
lcolor(black) addlabel xlabel(#8) xtitle("SREP Funding (USD Millions)") ///
ytitle("Number of Projects") title("Distribution of SREP Funding Across All Projects") ///
name(F1, replace)

sum target_cf
histogram target_cf, bin(10) frequency fcolor(eltgreen) ///
lcolor(black) addlabel xtitle("Target Co-Financing (USD Millions)") ///
ytitle("Number of Projects") ///
title("Target Co-Financing from Other Sources Across All Projects") ///
name(F2, replace)

sum actual_cf
histogram actual_cf, bin(10) frequency fcolor(eltgreen) ///
lcolor(black) addlabel xtitle("Actual Co-Financing (USD Millions)") ///
ytitle("Number of Projects") ///
title("Actual Co-Financing Across All Projects") ///
name(F3, replace)

sum actual_cf if actual_cf!=0
histogram actual_cf if actual_cf!=0, bin(10) frequency fcolor(eltgreen) ///
lcolor(black) addlabel xtitle("Actual Co-Financing (USD Millions)") ///
ytitle("Number of Projects") ///
title("Actual (Non-Zero) Co-Financing Across All Projects") ///
name(F3_non0, replace)

*******************************************************************************
// regressions 

//impact of renewable energy spending (x) on renewable energy generation (y)
reg actual_output SREP_fund, robust
eststo r1 

reg target_output SREP_fund target_cf, robust
eststo r2

reg actual_output actual_cf actual_mdb_cf, robust
eststo r3

esttab r1 r2 r3, b se stats(N r2) noconstant

graph twoway (lfit actual_output SREP_fund, title("SREP Funding on Actual Output") ///
xtitle("SREP Funding (USD Mil)") ytitle("Actual Renewable Energy Output (MWh)") ///
legend(off) name("r1", replace)) ///
(scatter actual_output SREP_fund) 

graph twoway (lfit target_output target_cf, title("Target Co-Financing on Target Output") ///
xtitle("Target Co-Financing (USD Mil)") ytitle("Target Renewable Energy Output (MWh)") ///
legend(off) name("r2", replace)) ///
(scatter target_output target_cf) 

graph twoway (lfit actual_output actual_cf, title("Actual Co-Financing on Actual Output") ///
xtitle("Actual Co-Financing (USD Mil)") ytitle("Actual Renewable Energy Output (MWh)") ///
legend(off) name("r3", replace)) ///
(scatter actual_output actual_cf) 


//impact of renewable energy generation (x) on greenhouse gas emissions (y)
reg target_ghg target_output, robust
eststo p1

reg actual_ghg actual_output, robust
eststo p2

reg life_target_ghg target_output, robust
eststo p3

esttab p1 p2 p3, b se stats(N r2) noconstant

graph twoway (lfit target_ghg target_output, title("Target GHG Emissions Avoided by Target Energy Output") xtitle("Target Renewable Energy Output (MWh)") ytitle("Target GHG Emissions Avoided (Tons of CO2)" , margin(medium)) legend(off) name("p1", replace)) ///
(scatter target_ghg target_output) 

graph twoway (lfit actual_ghg actual_output, title("Emissions Avoided by Energy Output") xtitle("Actual Renewable Energy Output (MWh)") ytitle("GHG Emissions Avoided (Tons of CO2)" , margin(medium)) legend(off) name("p2", replace)) ///
(scatter actual_ghg actual_output) 

graph twoway (lfit life_target_ghg target_output, title("Lifetime Target Emissions Avoided by Target Output") xtitle("Target Renewable Energy Output (MWh)") ytitle("Lifetime Target GHG Emissions Avoided (Tons of CO2)" , margin(medium)) legend(off) name("p3", replace)) ///
(scatter life_target_ghg target_output) 

save climate_investment_funds.dta, replace


log close












