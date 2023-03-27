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
BLCS <- read.csv(paste(path,"BLCS.csv",sep=""))


####stratify lung_risk into risk categories
BLCS$risk_category[BLCS$Lung_Risk < 65] <- 0
BLCS$risk_category[BLCS$Lung_Risk >= 65 & BLCS$Lung_Risk < 75] <- 1
BLCS$risk_category[BLCS$Lung_Risk >= 75] <- 2

####subset by chronological age
younger <- subset (BLCS, Age<65)
older <- subset (BLCS, Age>=65)

####generate Kaplan-Meier curves for entire BLCS cohort (Figure 3a)
fit <- survfit(Surv(Follow_up, Lung_cancer_death) ~ risk_category, data = BLCS)

res = ggsurvplot(fit, data = BLCS, 
                 xlab = "Years since CXR",  
                 font.x =c(24), xlim = c(0,10), break.x.by = 2, font.tickslab = c(20),
                 risk.table = FALSE,
                 ylab = "Survival probability", 
                 font.y =c(24), ylim = c(0,1),  break.y.by = 0.5,
                 legend.labs = c("<65 years", "65-75 years", ">75 years"),
                 censor = FALSE, pval = TRUE, break.time.by = 5, legend = "none", 
                 pval.coord =c(0.2, 0.2),
                 palette= c("#072A69",  "#0D7DB7", "#FD9738"))
print(res)
####compare individual risk categories
pairwise_survdiff(Surv(Follow_up, Lung_cancer_death) ~ risk_category,data=BLCS)

####Cox proportional hazard model
###univariable
summary(coxph(Surv(Follow_up, Lung_cancer_death)~ factor(risk_category), data=BLCS))

###mulitvariable
summary(coxph(Surv(Follow_up, Lung_cancer_death)~ factor(risk_category) + Age + Sex + factor(Race) +  
                factor(Smoking_status) + factor(Stage) + factor(Treatment) +  BMI, data=BLCS))


####generate Forest plot (Figure 3a)
forest_data <- data.frame(coef=c(1.00, 1.74, 3.30, 1.00, 1.28, 2.33),
                          low=c(NA, 1.50, 2.07, NA, 0.81, 1.36),
                          high=c(NA, 2.64, 5.25, NA, 2.02, 3.99))
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


####generate Kaplan-Meier curves for chronologically (<65y) younger BLCS patients (Figure 3b)
fit <- survfit(Surv(Follow_up, Lung_cancer_death) ~ risk_category, data = younger)

res = ggsurvplot(fit, data = younger, 
                 xlab = "Years since CXR",  
                 font.x =c(24), xlim = c(0,10), break.x.by = 2, font.tickslab = c(20),
                 risk.table = FALSE,
                 ylab = "Survival probability", 
                 font.y =c(24), ylim = c(0,1),  break.y.by = 0.5,
                 legend.labs = c("<65 years", "65-75 years", ">75 years"),
                 censor = FALSE, pval = TRUE, break.time.by = 5, legend = "none", 
                 pval.coord =c(0.2, 0.2),
                 palette= c("#072A69",  "#0D7DB7", "#FD9738"))
print(res)

####compare individual risk categories
pairwise_survdiff(Surv(Follow_up, Lung_cancer_death) ~ risk_category,data=younger)

####Cox proportional hazard model
###univariable
summary(coxph(Surv(Follow_up, Lung_cancer_death)~ factor(risk_category), data=younger))

###mulitvariable
summary(coxph(Surv(Follow_up, Lung_cancer_death)~ factor(risk_category) + Age + Sex + factor(Race) +  
                factor(Smoking_status) + factor(Stage) + factor(Treatment) +  BMI, data=younger))


####generate Forest plot (Figure 3b)
forest_data <- data.frame(coef=c(1.00, 1.54, 1.89, 1.00, 1.47, 1.87),
                          low=c(NA, 0.93, 0.88, NA, 0.84, 0.78),
                          high=c(NA, 2.55, 4.07, NA, 2.56, 4.45))
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

####generate Kaplan-Meier curves for chronologically (>65y) older BLCS patients (Figure 3c)
fit <- survfit(Surv(Follow_up, Lung_cancer_death) ~ risk_category, data = older)

res = ggsurvplot(fit, data = older, 
                 xlab = "Years since CXR",  
                 font.x =c(24), xlim = c(0,10), break.x.by = 2, font.tickslab = c(20),
                 risk.table = FALSE,
                 ylab = "Survival probability", 
                 font.y =c(24), ylim = c(0,1),  break.y.by = 0.5,
                 legend.labs = c("<65 years", "65-75 years", ">75 years"),
                 censor = FALSE, pval = TRUE, break.time.by = 5, legend = "none", 
                 pval.coord =c(0.2, 0.2),
                 palette= c("#072A69",  "#0D7DB7", "#FD9738"))
print(res)

####compare individual risk categories
pairwise_survdiff(Surv(Follow_up, Lung_cancer_death) ~ risk_category,data=older)

####Cox proportional hazard model
###univariable
summary(coxph(Surv(Follow_up, Lung_cancer_death)~ factor(risk_category), data=older))

###mulitvariable
summary(coxph(Surv(Follow_up, Lung_cancer_death)~ factor(risk_category) + Age + Sex + factor(Race) +  
                factor(Smoking_status) + factor(Stage) + factor(Treatment) +  BMI, data=older))


####generate Forest plot (Figure 3c)
forest_data <- data.frame(coef=c(1.00, 2.23, 5.02, 1.00, 1.33, 2.96),
                          low=c(NA, 0.89, 1.96, NA, 0.50, 1.07),
                          high=c(NA, 5.60, 12.82, NA, 3.51, 8.16))
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


#############################Supplementary Figure 2#############################
###generate box plots "Sex", "Obese", "Smoking_status" and "Stage" using code below
BLCS$Sex <- factor(BLCS$Sex , levels=c(2,1))


ggplot(BLCS, aes(x=factor(Stage), y=Lung_Risk)) + 
  geom_boxplot(
    color="blue",
    fill="blue",
    alpha=0.2,
    outlier.colour="dark orange",
    outlier.fill="red",
    outlier.size=1.5) + 
  theme_classic()


#############################Supplementary Figure 9a#############################
###import data
FEV1_data <- read.csv(paste(path,"FEV1_data.csv",sep=""),header=T)


####correlation between Lung_Risk and conventional Lung_Age
p = ggplot(FEV1_data, aes(x=Lung_Risk, y=Lung_age)) +
  geom_point(color="black") +
  xlab("CXR Lung-Risk") +
  ylab("Lung-Age") +
  geom_smooth(method=lm , color="black", fill="black", se=TRUE) +
  theme_classic(base_size=20)

p + stat_cor(method="pearson")


#############################Supplementary Figure 9b and 9c#############################

####Cox proportional hazard model
###univariable Lung-Risk
summary(coxph(Surv(Follow_up, Lung_cancer_death)~factor(risk_category) , data=FEV1_data))

###multivariable Lung-Risk
summary(coxph(Surv(Follow_up, Lung_cancer_death)~ factor(risk_category) + Sex + factor(Race) + Age + 
                factor(Smoking_status) + factor(Stage) + factor(Treatment) + BMI, data=FEV1_data))



###univariable Lung-Age
summary(coxph(Surv(Follow_up, Lung_cancer_death)~factor(Lung_age_category) , data=FEV1_data))

###multivariable Lung-Age
summary(coxph(Surv(Follow_up, Lung_cancer_death)~ factor(Lung_age_category) + Sex + factor(Race) + Age +
                factor(Smoking_status) + factor(Stage) + factor(Treatment) + BMI, data=FEV1_data))


####generate Forest plot (Supplementary Figure 9b and 9c by using results of Cox regression models above)
forest_data <- data.frame(coef=c(1.00, 1.33, 2.30, 1.00, 1.08, 1.37),
                          low=c(NA, 0.73, 1.55, NA, 0.57, 0.89),
                          high=c(NA, 2.41, 3.43, NA, 2.02, 2.11))
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


#############################Supplementary Figure 10a#############################
####correlation between Lung_Risk and conventional Lung_Age
p = ggplot(FEV1_data, aes(x=Lung_Risk, y=FEV1)) +
  geom_point(color="black") +
  xlab("CXR Lung-Risk") +
  ylab("FEV1 (l)") +
  geom_smooth(method=lm , color="black", fill="black", se=TRUE) +
  theme_classic(base_size=20)

p + stat_cor(method="pearson")


#############################Supplementary Figure 10b#############################

####Cox proportional hazard model
###univariable Lung-Risk
summary(coxph(Surv(Follow_up, Lung_cancer_death)~factor(risk_category) , data=FEV1_data))

###multivariable Lung-Risk
summary(coxph(Surv(Follow_up, Lung_cancer_death)~ factor(risk_category) + FEV1 + Sex + factor(Race) + Age + 
                factor(Smoking_status) + factor(Stage) + factor(Treatment) + BMI, data=FEV1_data))


####generate Forest plot Supplementary Figure 10b using results of Cox regression models above
forest_data <- data.frame(coef=c(1.00, 1.94, 3.37, 1.00, 1.31, 1.99),
                          low=c(NA, 1.22, 2.00, NA, 0.79, 1.07),
                          high=c(NA, 3.08, 5.68, NA, 2.19, 3.68))
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



