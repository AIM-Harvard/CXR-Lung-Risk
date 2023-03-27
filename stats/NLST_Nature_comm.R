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
NLST <- read.csv(paste(path,"NLST.csv",sep=""))


####stratify lung_risk into risk categories
NLST$risk_category[NLST$Lung_Risk < 65] <- 0
NLST$risk_category[NLST$Lung_Risk >= 65 & NLST$Lung_Risk < 75] <- 1
NLST$risk_category[NLST$Lung_Risk >= 75] <- 2

#############################Figure 2b#############################
####generate Kaplan-Meier curves
fit <- survfit(Surv(Follow_up, Lung_disease_death) ~ risk_category, data = NLST)

res = ggsurvplot(fit, data = NLST, 
                 xlab = "Years since CXR",  
                 font.x =c(24), xlim = c(0,12), break.x.by = 2, font.tickslab = c(20),
                 risk.table = FALSE,
                 ylab = "Survival probability",
                 font.y =c(24), ylim = c(0.5,1),  break.y.by = 0.25,
                 legend.labs = c("<65 years", "65-75 years", ">75 years"),
                 censor = FALSE, pval = TRUE, break.time.by = 5, legend = "none", 
                 pval.coord =c(1.5, 0.65),
                 palette= c("#072A69",  "#0D7DB7", "#FD9738"))

print(res)
####compare individual risk categories
pairwise_survdiff(Surv(Follow_up, Lung_disease_death) ~ risk_category, data=NLST)

####Cox proportional hazard model
###univariable
summary(coxph(Surv(Follow_up, Lung_disease_death)~factor(risk_category), data=NLST))

###mulitvariable
summary(coxph(Surv(Follow_up, Lung_disease_death)~factor(risk_category) + Age + factor(Race) + Sex + BMI +
                Prior_cancer + Smoking_status + Packyears + History_of_Diabetes + History_of_Heart_Disease + 
                History_of_Stroke + History_of_Hypertension + Nodule + Atelectasis + Pleural_Fibrosis + 
                Lung_Fibrosis + COPD_Emphysema + Lung_Opacity + Cardiac_Abnormality + Lymphadenopathy + 
                Bone_Chest_Wall_Lesion, data=NLST))

####generate Forest plot (Figure 2b)
forest_data <- data.frame(coef=c(1.00, 3.03, 10.92, 1.00, 2.48, 6.48),
                          low=c(NA, 2.34, 8.07, NA, 1.88, 4.52),
                          high=c(NA, 3.93, 14.77, NA, 3.29, 9.31))
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

#############################Supplementary Figure 1b#############################
###generate box plots "Sex", "Obese", "Smoking_status", Nodule, "Lung_Fibrosis", "COPD_Emphysema",
###"Atelectasis", "Opacification", Pleural_Fibrosis","Bone_Chest_Wall_Lesion",
###"Cardiac_Abnormality", "Lymphadenopathy" using code below

ggplot(NLST, aes(x=factor(Lymphadenopathy), y=Lung_Risk)) + 
  geom_boxplot(
    color="blue",
    fill="blue",
    alpha=0.2,
    outlier.colour="dark orange",
    outlier.fill="red",
    outlier.size=1.5) + 
  theme_classic()



#############################Supplementary Figure 6c#############################
####generate Kaplan-Meier curves
fit <- survfit(Surv(Follow_up, Lung_cancer_death) ~ risk_category, data = NLST)

res = ggsurvplot(fit, data = NLST, 
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
####compare individual risk categories
pairwise_survdiff(Surv(Follow_up, Lung_cancer_death) ~ risk_category, data=NLST)

####Cox proportional hazard model
###univariable
summary(coxph(Surv(Follow_up, Lung_cancer_death)~factor(risk_category), data=NLST))

###mulitvariable 
summary(coxph(Surv(Follow_up, Lung_cancer_death)~factor(risk_category) + Age + factor(Race) + Sex + BMI +
                Prior_cancer + Smoking_status + Packyears + History_of_Diabetes + History_of_Heart_Disease + 
                History_of_Stroke + History_of_Hypertension + Nodule + Atelectasis + Pleural_Fibrosis + 
                Lung_Fibrosis + COPD_Emphysema + Lung_Opacity + Cardiac_Abnormality + Lymphadenopathy + 
                Bone_Chest_Wall_Lesion, data=NLST))



####generate Forest plot (Supplementary Figure 6c by using results of Cox regression models above)
forest_data <- data.frame(coef=c(1.00, 2.56, 6.32, 1.00, 2.22, 4.45),
                          low=c(NA, 1.92, 4.36, NA, 1.63, 2.88),
                          high=c(NA, 3.40, 9.16, NA, 3.03, 6.88))
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


#############################Supplementary Figure 7a and 7b#############################

####subset by Sex
NLST_male <- subset (NLST, Sex==0)
NLST_female <- subset (NLST, Sex==1)

####rerun code below with dataset "NLST_female" to generate Supplementary Figure 7a
####rerun code below with dataset "NLST_male" to generate Supplementary Figure 7b


####generate Kaplan-Meier curves
fit <- survfit(Surv(Follow_up, Lung_disease_death) ~ risk_category, data = NLST_male)

res = ggsurvplot(fit, data = NLST_male, 
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
####compare individual risk categories
pairwise_survdiff(Surv(Follow_up, Lung_disease_death) ~ risk_category, data=NLST_male)

####Cox proportional hazard model
###univariable
summary(coxph(Surv(Follow_up, Lung_disease_death)~factor(risk_category), data=NLST_male))

###mulitvariable 
summary(coxph(Surv(Follow_up, Lung_disease_death)~factor(risk_category) + Age + factor(Race) + BMI +
                Prior_cancer + Smoking_status + Packyears + History_of_Diabetes + History_of_Heart_Disease + 
                History_of_Stroke + History_of_Hypertension + Nodule  + Pleural_Fibrosis + 
                Lung_Fibrosis + COPD_Emphysema + Lung_Opacity + Cardiac_Abnormality + Lymphadenopathy + 
                Bone_Chest_Wall_Lesion, data=NLST_female))

summary(coxph(Surv(Follow_up, Lung_disease_death)~factor(risk_category) + Age + factor(Race) + BMI +
                Prior_cancer + Smoking_status + Packyears + History_of_Diabetes + History_of_Heart_Disease + 
                History_of_Stroke + History_of_Hypertension + Nodule + Atelectasis + Pleural_Fibrosis + 
                Lung_Fibrosis + COPD_Emphysema + Cardiac_Abnormality + Lymphadenopathy + 
                Bone_Chest_Wall_Lesion, data=NLST_male))


####generate Forest plot (Supplementary Figure 7a and 7b by using results of Cox regression models above)
forest_data <- data.frame(coef=c(1.00, 4.23, 16.87, 1.00, 3.29, 9.33),
                          low=c(NA, 2.73, 10.58, NA, 2.09, 5.51),
                          high=c(NA, 6.56, 26.90, NA, 5.18, 15.81))
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



#############################Supplementary Figure 8a and 8b#############################

####subset by chronological age
NLST_younger <- subset (NLST, Age<65)
NLST_older <- subset (NLST, Age>=65)

####rerun code below with dataset "NLST_younger" to generate Supplementary Figure 8a
####rerun code below with dataset "NLST_older" to generate Supplementary Figure 8b


####generate Kaplan-Meier curves
fit <- survfit(Surv(Follow_up, Lung_disease_death) ~ risk_category, data = NLST_older)

res = ggsurvplot(fit, data = NLST_older, 
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
####compare individual risk categories
pairwise_survdiff(Surv(Follow_up, Lung_disease_death) ~ risk_category, data=NLST_older)

####Cox proportional hazard model
###univariable
summary(coxph(Surv(Follow_up, Lung_disease_death)~factor(risk_category), data=NLST_older))

###mulitvariable 
summary(coxph(Surv(Follow_up, Lung_disease_death)~factor(risk_category) + Age + factor(Race) + Sex + BMI +
                Prior_cancer + Smoking_status + Packyears + History_of_Diabetes + History_of_Heart_Disease + 
                History_of_Stroke + History_of_Hypertension + Nodule + Pleural_Fibrosis + 
                Lung_Fibrosis + COPD_Emphysema + Lung_Opacity + Cardiac_Abnormality + 
                Lymphadenopathy, data=NLST_younger))

summary(coxph(Surv(Follow_up, Lung_disease_death)~factor(risk_category) + Age + factor(Race) + Sex + BMI +
                Prior_cancer + Smoking_status + Packyears + History_of_Diabetes + History_of_Heart_Disease + 
                History_of_Stroke + History_of_Hypertension + Nodule + Atelectasis + Pleural_Fibrosis + 
                Lung_Fibrosis + COPD_Emphysema + Cardiac_Abnormality + 
                Bone_Chest_Wall_Lesion, data=NLST_older))

####generate Forest plot (Supplementary Figure 6c by using results of Cox regression models above)
forest_data <- data.frame(coef=c(1.00, 5.33, 17.88, 1.00, 4.68, 13.05),
                          low=c(NA, 2.33, 7.70, NA, 2.03, 5.45),
                          high=c(NA, 12.16, 41.52, NA, 10.78, 31.27))
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

