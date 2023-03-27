####load necessary libraries
if(!require(survival))
{
  install.packages("survival")
  library(survival)
}

if(!require(survminer))
{
  install.packages("survminer")
  library(survminer)
}
if(!require(ggplot2))
{
  install.packages("ggplot2")
  library(ggplot2)
}
if(!require(ggpubr))
{
  install.packages("ggpubr")
  library(ggpubr)
}
if(!require(forestplot))
{
  install.packages("forestplot")
  library(forestplot)
}

###Set path to dataset files
path = "~/Academics/MGH/LC_Age/Data/Datasets/Datasets/"

####import data
PLCO <- read.csv(paste(path,"PLCO.csv",sep=""))

####stratify lung_risk into risk categories
PLCO$risk_category[PLCO$Lung_Risk < 65] <- 0
PLCO$risk_category[PLCO$Lung_Risk >= 65 & PLCO$Lung_Risk < 75] <- 1
PLCO$risk_category[PLCO$Lung_Risk >= 75] <- 2


#############################Figure 2a and Supplementary Figure 3a#############################
####generate Kaplan-Meier curves for entire PLCO cohort
fit <- survfit(Surv(Follow_up, Lung_disease_death) ~ risk_category, data = PLCO)

res = ggsurvplot(fit, data = PLCO, 
                 xlab = "Years since CXR",  
                 font.x =c(24), xlim = c(0,20), break.x.by = 4, font.tickslab = c(20),
                 risk.table = FALSE,
                 ylab = "Survival probability",
                 font.y =c(24), ylim = c(0.5,1),  break.y.by = 0.25,
                 legend.labs = c("<65 years", "65-75 years", ">75 years"),
                 censor = FALSE, pval = TRUE, break.time.by = 5, legend = "none", 
                 pval.coord =c(1.5, 0.65),
                 palette= c("#072A69",  "#0D7DB7", "#FD9738"))

print(res)
####compare individual risk categories using pairwise test
pairwise_survdiff(Surv(Follow_up, Lung_disease_death) ~ risk_category, data=PLCO)

####Cox proportional hazard model
###univariable
summary(coxph(Surv(Follow_up, Lung_disease_death)~factor(risk_category), data=PLCO))

###mulitvariable
summary(coxph(Surv(Follow_up, Lung_disease_death)~factor(risk_category) + Age + factor(Race) + Sex + BMI +
                Prior_cancer + Smoking_status + Packyears + History_of_Diabetes + History_of_Heart_Disease + 
                History_of_Stroke + History_of_Hypertension + Nodule + Atelectasis + Pleural_Fibrosis + 
                Lung_Fibrosis + COPD_Emphysema + Lung_Opacity + Cardiac_Abnormality + Lymphadenopathy + 
                Bone_Chest_Wall_Lesion, data=PLCO))


####Generate Forest plot (Figure 2a)
forest_data <- data.frame(coef=c(1.00, 5.74, 31.45, 1.00, 3.52, 11.86),
                          low=c(NA, 4.69, 24.43, NA, 2.81, 8.64),
                          high=c(NA, 7.01, 40.48, NA, 4.41, 16.27))
row_names <- cbind(c( "Group", "<65 y Reference", "≥65 - <75 y", ">75 y", "<65 y Reference", "≥65 - <75 y", ">75 y"),
                   c("HR", forest_data$coef))
forest_data <- rbind(rep(NA, 3), forest_data)
forestplot(labeltext = row_names,
           forest_data[,c("coef", "low", "high")],
           zero = 1,
           xlog = TRUE,
           ci.vertices = TRUE,
           ci.vertices.height = 0.04,
           col = fpColors(lines="black", box="black", zero = "black"),
           fn.ci_norm = fpDrawNormalCI,
           new_page = TRUE)

#############################Supplementary Figure 1a#############################
###generate box plots "Sex", "Obese", "Smoking_status", Nodule, "Lung_Fibrosis", "COPD_Emphysema",
###"Atelectasis", "Opacification", Pleural_Fibrosis","Bone_Chest_Wall_Lesion",
###"Cardiac_Abnormality", "Lymphadenopathy" using code below

PLCO$Smoking_status <- factor(PLCO$Smoking_status , levels=c(0,2,1))

ggplot(PLCO, aes(x=factor(Lymphadenopathy), y=Lung_Risk)) + 
  geom_boxplot(
    color="blue",
    fill="blue",
    alpha=0.2,
    outlier.colour="dark orange",
    outlier.fill="red",
    outlier.size=1.5) + 
  theme_classic()




#############################Supplementary Figure 3b and 3c#############################
####subset by Smoking Status
PLCO_smoke_only = subset (PLCO, Smoking_status!=0)
PLCO_no_smoke = subset (PLCO, Smoking_status ==0)

####rerun code below with dataset "PLCO_smoke_only" to generate Supplementary Figure 3b
####rerun code below with dataset "PLCO_no_smoke" to generate Supplementary Figure 3c


####generate Kaplan-Meier curves
fit <- survfit(Surv(Follow_up, Lung_disease_death) ~ risk_category, data = PLCO_no_smoke)

res = ggsurvplot(fit, data = PLCO_no_smoke, 
                 xlab = "Years since CXR",  
                 font.x =c(24), xlim = c(0,20), break.x.by = 4, font.tickslab = c(20),
                 risk.table = FALSE,
                 ylab = "Survival probability",
                 font.y =c(24), ylim = c(0.5,1),  break.y.by = 0.25,
                 legend.labs = c("<65 years", "65-75 years", ">75 years"),
                 censor = FALSE, pval = TRUE, break.time.by = 5, legend = "none", 
                 pval.coord =c(1.5, 0.65),
                 palette= c("#072A69",  "#0D7DB7", "#FD9738"))

print(res)
####compair individual risk categories
pairwise_survdiff(Surv(Follow_up, Lung_disease_death) ~ risk_category, data=PLCO_no_smoke)

####Cox proportional hazard model
###univariable
summary(coxph(Surv(Follow_up, Lung_disease_death)~factor(risk_category), data=PLCO_no_smoke))

###mulitvariable PLCO in those that have smoked
summary(coxph(Surv(Follow_up, Lung_disease_death)~factor(risk_category) + Age + factor(Race) + Sex + BMI +
                Prior_cancer + Smoking_status + Packyears + History_of_Diabetes + History_of_Heart_Disease + 
                History_of_Stroke + History_of_Hypertension + Nodule + Atelectasis + Pleural_Fibrosis + 
                Lung_Fibrosis + COPD_Emphysema + Lung_Opacity + Cardiac_Abnormality + Lymphadenopathy + 
                Bone_Chest_Wall_Lesion, data=PLCO_smoke_only))


###mulitvariable PLCO in those that have never smoked
summary(coxph(Surv(Follow_up, Lung_disease_death)~factor(risk_category) + Age + factor(Race) + Sex + BMI +
                Prior_cancer + History_of_Diabetes + History_of_Heart_Disease + 
                History_of_Stroke + History_of_Hypertension + Nodule + Pleural_Fibrosis + 
                Lung_Fibrosis + COPD_Emphysema + Lung_Opacity + Cardiac_Abnormality + Lymphadenopathy + 
                Bone_Chest_Wall_Lesion, data=PLCO_no_smoke))

####generate Forest plot (Supplementary Figure 3b and 3c by using results of Cox regression models above)
forest_data <- data.frame(coef=c(1.00, 3.81, 15.52, 1.00, 1.67, 5.91),
                          low=c(NA, 2.46, 4.81, NA, 1.01, 1.67),
                          high=c(NA, 5.91, 50.11, NA, 2.76, 20.87))
row_names <- cbind(c( "Group", "<65 y Reference", "≥65 - <75 y", ">75 y", "<65 y Reference", "≥65 - <75 y", ">75 y"),
                   c("HR", forest_data$coef))
forest_data <- rbind(rep(NA, 3), forest_data)
forestplot(labeltext = row_names,
           forest_data[,c("coef", "low", "high")],
           zero = 1,
           xlog = TRUE,
           ci.vertices = TRUE,
           ci.vertices.height = 0.04,
           col = fpColors(lines="black", box="black", zero = "black"),
           fn.ci_norm = fpDrawNormalCI,
           new_page = TRUE)



#############################Supplementary Figure 4a and 4b#############################

####subset by Sex
PLCO_male <- subset (PLCO, Sex==1)
PLCO_female <- subset (PLCO, Sex==2)

####rerun code below with dataset "PLCO_female" to generate Supplementary Figure 4a
####rerun code below with dataset "PLCO_male" to generate Supplementary Figure 4b



####generate Kaplan-Meier curves
fit <- survfit(Surv(Follow_up, Lung_disease_death) ~ risk_category, data = PLCO_male)

res = ggsurvplot(fit, data = PLCO_male, 
                 xlab = "Years since CXR",  
                 font.x =c(24), xlim = c(0,20), break.x.by = 4, font.tickslab = c(20),
                 risk.table = FALSE,
                 ylab = "Survival probability",
                 font.y =c(24), ylim = c(0.5,1),  break.y.by = 0.25,
                 legend.labs = c("<65 years", "65-75 years", ">75 years"),
                 censor = FALSE, pval = TRUE, break.time.by = 5, legend = "none", 
                 pval.coord =c(1.5, 0.65),
                 palette= c("#072A69",  "#0D7DB7", "#FD9738"))

print(res)
####compare individual risk categories
pairwise_survdiff(Surv(Follow_up, Lung_disease_death) ~ risk_category, data=PLCO_male)

####Cox proportional hazard model
###univariable
summary(coxph(Surv(Follow_up, Lung_disease_death)~factor(risk_category), data=PLCO_male))

###mulitvariable 
summary(coxph(Surv(Follow_up, Lung_disease_death)~factor(risk_category) + Age + factor(Race) + BMI +
                Prior_cancer + Smoking_status + Packyears + History_of_Diabetes + History_of_Heart_Disease + 
                History_of_Stroke + History_of_Hypertension + Nodule + Atelectasis + Pleural_Fibrosis + 
                Lung_Fibrosis + COPD_Emphysema + Lung_Opacity + Cardiac_Abnormality + Lymphadenopathy + 
                Bone_Chest_Wall_Lesion, data=PLCO_male))


####generate Forest plot (Supplementary Figure 4a and 4b by using results of Cox regression models above)
forest_data <- data.frame(coef=c(1.00, 4.75, 24.44, 1.00, 3.16, 10.28),
                          low=c(NA, 3.66, 17.92, NA, 2.37, 7.01),
                          high=c(NA, 6.15, 33.31, NA, 4.21, 15.09))
row_names <- cbind(c( "Group", "<65 y Reference", "≥65 - <75 y", ">75 y", "<65 y Reference", "≥65 - <75 y", ">75 y"),
                   c("HR", forest_data$coef))
forest_data <- rbind(rep(NA, 3), forest_data)
forestplot(labeltext = row_names,
           forest_data[,c("coef", "low", "high")],
           zero = 1,
           xlog = TRUE,
           ci.vertices = TRUE,
           ci.vertices.height = 0.04,
           col = fpColors(lines="black", box="black", zero = "black"),
           fn.ci_norm = fpDrawNormalCI,
           new_page = TRUE)


#############################Supplementary Figure 5a and 5b#############################

####subset by chronolgocal age
PLCO_younger <- subset (PLCO, Age<65)
PLCO_older <- subset (PLCO, Age>=65)

####rerun code below with dataset "PLCO_younger" to generate Supplementary Figure 5a
####rerun code below with dataset "PLCO_older" to generate Supplementary Figure 5b



####generate Kaplan-Meier curves
fit <- survfit(Surv(Follow_up, Lung_disease_death) ~ risk_category, data = PLCO_older)

res = ggsurvplot(fit, data = PLCO_older, 
                 xlab = "Years since CXR",  
                 font.x =c(24), xlim = c(0,20), break.x.by = 4, font.tickslab = c(20),
                 risk.table = FALSE,
                 ylab = "Survival probability",
                 font.y =c(24), ylim = c(0.5,1),  break.y.by = 0.25,
                 legend.labs = c("<65 years", "65-75 years", ">75 years"),
                 censor = FALSE, pval = TRUE, break.time.by = 5, legend = "none", 
                 pval.coord =c(1.5, 0.65),
                 palette= c("#072A69",  "#0D7DB7", "#FD9738"))

print(res)
####compare individual risk categories
pairwise_survdiff(Surv(Follow_up, Lung_disease_death) ~ risk_category, data=PLCO_older)

####Cox proportional hazard model
###univariable
summary(coxph(Surv(Follow_up, Lung_disease_death)~factor(risk_category), data=PLCO_older))

###mulitvariable 
summary(coxph(Surv(Follow_up, Lung_disease_death)~factor(risk_category) + Age + factor(Race) + Sex + BMI +
                Prior_cancer + Smoking_status + Packyears + History_of_Diabetes + History_of_Heart_Disease + 
                History_of_Stroke + History_of_Hypertension + Nodule + Atelectasis + Pleural_Fibrosis + 
                Lung_Fibrosis + COPD_Emphysema + Lung_Opacity + Cardiac_Abnormality + Lymphadenopathy + 
                Bone_Chest_Wall_Lesion, data=PLCO_older))


####generate Forest plot (Supplementary Figure 5a and 5b by using results of Cox regression models above)
forest_data <- data.frame(coef=c(1.00, 3.79, 21.81, 1.00, 2.84, 10.36),
                          low=c(NA, 2.76, 15.17, NA, 2.03, 6.78),
                          high=c(NA, 5.22, 31.36, NA, 3.98, 15.84))
row_names <- cbind(c( "Group", "<65 y Reference", "≥65 - <75 y", ">75 y", "<65 y Reference", "≥65 - <75 y", ">75 y"),
                   c("HR", forest_data$coef))
forest_data <- rbind(rep(NA, 3), forest_data)
forestplot(labeltext = row_names,
           forest_data[,c("coef", "low", "high")],
           zero = 1,
           xlog = TRUE,
           ci.vertices = TRUE,
           ci.vertices.height = 0.04,
           col = fpColors(lines="black", box="black", zero = "black"),
           fn.ci_norm = fpDrawNormalCI,
           new_page = TRUE)


#############################Supplementary Figure 6a and 6b#############################
####select lung cancer screening eligible participants
PLCO_screening_eligible = subset (PLCO, Smoking_status !=0 & Packyears >=30, Stop_smoking <15)

####rerun code below with dataset "PLCO" to generate Supplementary Figure 6a
####rerun code below with dataset "PLCO_eligible" to generate Supplementary Figure 6b

####generate Kaplan-Meier curves
fit <- survfit(Surv(Follow_up, Lung_cancer_death) ~ risk_category, data = PLCO)

res = ggsurvplot(fit, data = PLCO_screening_eligible, 
                 xlab = "Years since CXR",  
                 font.x =c(24), xlim = c(0,12), break.x.by = 4, font.tickslab = c(20),
                 risk.table = FALSE,
                 ylab = "Survival probability",
                 font.y =c(24), ylim = c(0.5,1),  break.y.by = 0.25,
                 legend.labs = c("<65 years", "65-75 years", ">75 years"),
                 censor = FALSE, pval = TRUE, break.time.by = 5, legend = "none", 
                 pval.coord =c(1.5, 0.65),
                 palette= c("#072A69",  "#0D7DB7", "#FD9738"))

print(res)
####compair individual risk categories
pairwise_survdiff(Surv(Follow_up, Lung_cancer_death) ~ risk_category, data=PLCO_screening_eligible)

####Cox proportional hazard model
###univariable
summary(coxph(Surv(Follow_up, Lung_cancer_death)~factor(risk_category), data=PLCO_screening_eligible))

###mulitvariable 
summary(coxph(Surv(Follow_up, Lung_cancer_death)~factor(risk_category) + Age + factor(Race) + Sex + BMI +
                Prior_cancer + Smoking_status + Packyears + History_of_Diabetes + History_of_Heart_Disease + 
                History_of_Stroke + History_of_Hypertension + Nodule + Atelectasis + Pleural_Fibrosis + 
                Lung_Fibrosis + COPD_Emphysema + Lung_Opacity + Cardiac_Abnormality + Lymphadenopathy + 
                Bone_Chest_Wall_Lesion, data=PLCO_screening_eligible))



####generate Forest plot (Supplementary Figure 6a and 6b by using results of Cox regression models above)
forest_data <- data.frame(coef=c(1.00, 5.94, 27.43, 1.00, 3.81, 10.69),
                          low=c(NA, 4.45, 19.91, NA, 2.75, 6.71),
                          high=c(NA, 7.94, 39.80, NA, 5.28, 17.00))
row_names <- cbind(c( "Group", "<65 y Reference", "≥65 - <75 y", ">75 y", "<65 y Reference", "≥65 - <75 y", ">75 y"),
                   c("HR", forest_data$coef))
forest_data <- rbind(rep(NA, 3), forest_data)
forestplot(labeltext = row_names,
           forest_data[,c("coef", "low", "high")],
           zero = 1,
           xlog = TRUE,
           ci.vertices = TRUE,
           ci.vertices.height = 0.04,
           col = fpColors(lines="black", box="black", zero = "black"),
           fn.ci_norm = fpDrawNormalCI,
           new_page = TRUE)
