# causal-inference
To run the code, run "calc.m"
In this work I analyzed the causal effect of modifiable risk factors, including hypertension, smoking status, marriage status, work type, residence type, glucose levels, and BMI on the two leading causes of death worldwide: heart disease, and stroke.

The data set is used to infer causal relationship of modifiable risk factors on the outcome of heart disease and stroke. The dataset 	contains 5110 observations with 11 attributes:
•	Gender – male/female
•	Age
•	Hypertension: 0 if the patient doesn't have hypertension, 1 if the patient has hypertension
•	Ever married: "No" or "Yes"
•	Work type: "children", "Govt_jov", "Never_worked", "Private" or "Self-employed"
•	Residence type: "Rural" or "Urban"
•	Avg glucose level: average glucose level in blood
•	BMI: body mass index
•	Smoking status: "formerly smoked", "never smoked", "smokes" or "Unknown"
•	Heart disease: 0 if the patient doesn't have any heart diseases, 1 if the patient has a heart disease
•	Stroke: 1 if the patient had a stroke or 0 if not

In this work I used as treatment each one of the risk factors smoking, hypertension, residence type, and glucose levels, on the outcome of heart disease and stroke separately.  All other fields in the dataset were considered as potential confounders, i.e. when considering smoking as a treatment and stroke as an outcome, all other inputs, including heart disease, were taken as covariates, and considered as potential confounders. 

Link for the dataset: 
https://www.kaggle.com/fedesoriano/stroke-prediction-dataset/code?datasetId=1120859

To infer Average Treatment effect of the Treated (ATT), I used t-learner, s-learner, IPW, and propensity score matching, to account for the potential observed confounders.

