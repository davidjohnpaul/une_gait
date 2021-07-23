# MIT License
#
# Copyright (c) 2021 Matthew Cooper, David Paul, Jelena Schmalz and Xenia Schmalz
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

library(dplyr)
library(lme4)
library(lmerTest)
library(ggplot2)
library(gridExtra)

# Reading data
df_full <- read.csv("k3_data_with_fft_threshold_0.30.csv")

# Speed in m/s to km/h
df_full$Speed <- df_full$Speed * 3.6

# Adding walking/running column
df_full$Mode[df_full$Speed<=8] = "Walking"
df_full$Mode[df_full$Speed>8] = "Running"


#################
#### UNE DATA ###
#################

df <- df_full %>%
  filter(Data == "UNE")

# Excluding unneccessary datasets
df <- df %>%
  filter(Participant == "UNE02" |
           Participant == "UNE04" | 
           Participant == "UNE06" | 
           Participant == "UNE08" | 
           Participant == "UNE11" | 
           Participant == "UNE14")


# Walking data only
w <- df %>%
  filter(Mode=="Walking")

w %>%
  count(Participant)

# Outlier removal: by-participant SDs
w_sd <- w %>%
  group_by(Participant) %>%
  summarize(sd = sd(Duff))

w_sd$z_sd <- (w_sd$sd - mean(w_sd$sd)) / sd(w_sd$sd)
hist(w_sd$z_sd)
# Justification for excluding the two outliers

w <- w %>%
  filter(Participant != "UNE14" & Participant != "UNE04")

# Fitting LME
walking_lme <- lmer(Duff~Speed+(1+Speed|Participant),data=w)
summary(walking_lme)
ind_walk <- coef(walking_lme)$Participant

# # Checking if quadratic term gives better fit
# w$Speed_q <- w$Speed^2
# walking_lme_nonlin <- lmer(Duff~Speed+Speed_q+(1+Speed|Participant),data=w)
# summary(walking_lme_nonlin)
# 
# anova(walking_lme,walking_lme_nonlin)
# plot(w$Duff~w$Speed) + abline(w$Duff~Speed+Speed_q)

# Running data only
r <- df %>%
  filter(Mode=="Running")
r <- r %>%
  filter(Participant != "UNE14" & Participant != "UNE04")

# Plot Duff ~ speed
plot(r$Duff~r$speed) + abline(lm(r$Duff ~ r$speed))

# Fitting regression
running_model <- lmer(Duff~Speed+(1+Speed|Participant),data=r)
summary(running_model)

# # Checking if quadratic term gives better fit
# r$Speed_q <- r$Speed^2
# running_lme_nonlin <- lmer(Duff~Speed+Speed_q+(1+Speed|Participant),data=r)
# summary(walking_lme_nonlin)

# Pretty plot

p <- ggplot(df,aes(y=Duff,x=Speed,col=Participant,shape=Mode)) + geom_point() + geom_line() +
  xlim(0,15) + ggtitle("Walking and running data for six participants") + ylim(-100,1500) +
  xlab("Speed (km/h)") + ylab("Duffing stiffness")
p

# Removing outliers
df_tr <- df %>%
  filter(Participant != "UNE14" & Participant != "UNE04")
p_noout <- ggplot(df_tr,aes(y=Duff,x=Speed,col=Participant,shape=Mode)) + geom_point() + geom_line() +
  xlim(0,15) + 
  ggtitle("Walking and running data for four participants") + xlab("Speed (km/h)") + 
  ylim(-100,1500) + ylab("Duffing stiffness")
p_noout

grid.arrange(p,p_noout,nrow=1)

##################
### OTHER DATA ###
##################

other_data <- df_full %>%
  filter(Data != "UNE")

# Walking data only
w_o <- other_data %>%
  filter(Mode=="Walking")

w_o %>%
  count(Participant)

w_o <- w_o %>%
  filter(Participant != "WBDS03")
  
# Removing outliers
wo_sd <- w_o %>%
  group_by(Participant) %>%
  summarize(sd = sd(Duff))
hist(wo_sd$sd)

wo_sd$z_sd <- (wo_sd$sd - mean(wo_sd$sd)) / sd(wo_sd$sd)
hist(wo_sd$z_sd)


# # z-Duff
# w_o$z_Duff <- (w_o$Duff - mean(w_o$Duff)) / sd(w_o$Duff)
# hist(w_o$Duff)

# Excluding participants with outlier points
w_outliers <- wo_sd[wo_sd$sd > 100,]

wo_tr = subset(w_o, !(w_o$Participant %in% w_outliers$Participant))
hist(wo_tr$Duff)
summary(wo_tr$Duff)

# Fitting LME
o_walking_lme <- lmer(Duff~Speed+(1+Speed|Participant),data=wo_tr)
summary(o_walking_lme)
o_ind_walk <- coef(o_walking_lme)$Participant
plot(wo_tr$Duff~wo_tr$Speed)

# # Linear trend?
# o_walking_lme_nonlin <- lmer(Duff~Speed+Speed^2+(1|Participant),data=w_o)
# #summary(walking_lme_noslope)
# anova(o_walking_lme,o_walking_lme_noslope)

# Running data only
r_o <- other_data %>%
  filter(Mode=="Running")

# Plot Duff ~ speed
plot(r_o$Duff~r_o$speed) + abline(lm(r_o$Duff ~ r_o$speed))

# Fitting regression
running_model <- lm(Duff~speed,data=r)

summary(running_model)
residuals(running_model)




####################
### PRETTY PLOTS ###
####################

# Running & walking other data full
p <- ggplot(df,aes(y=Duff,x=Speed,col=Participant,shape=Mode)) + geom_point() + geom_line() +
  xlim(0,15) + ggtitle("Walking and running data for six participants") + ylim(-100,1500) +
  xlab("Speed (km/h)")
p

# Running & walking UNE data without 2 outliers
df_tr <- df %>%
  filter(Participant != "UNE14" & Participant != "UNE04")
p_noout <- ggplot(df_tr,aes(y=Duff,x=Speed,col=Participant,shape=Mode)) + geom_point() + geom_line() +
  xlim(0,15) + ggtitle("Walking and running data for four participants") + xlab("Speed (km/h)") + ylim(-100,1500)
p_noout

grid.arrange(p,p_noout,nrow=1)

# Running & walking other data
q <- ggplot(other_data,aes(y=Duff,x=Speed,col=Participant,shape=Mode)) + geom_point() + geom_line() +
  xlim(0,15) + ggtitle("Walking and running data for other participants") + 
  xlab("Speed (km/h)")
q
