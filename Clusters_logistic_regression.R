library(tidyverse)
library(lme4)
library(lmerTest) # with p-values in the summary() and anova() functions
library(nnet) # For multinom()
library(afex)
library(car)

ctrl <- glmerControl(optimizer="bobyqa", optCtrl = list(maxfun=100000), calc.derivs = T, check.conv.grad = .makeCC("warning", tol = 1e-3, relTol = NULL))

set_sum_contrasts() # use sum coding, necessary to make type III LR tests valid

df <- read.table(PATH_TO_CSV_FILE, sep = ";", dec = ".", header = T, fileEncoding = "utf-8", quote = "", na.strings = "NaN")
df = movie.info

df <- df %>% mutate(EmoCluster = as.factor(EmoCluster),
                    CogCluster = as.factor(CogCluster),
                    Genre1 = as.factor(Genre1),
                    Genre2 = as.factor(Genre2),
                    Genre3 = as.factor(Genre3),
                    TrendType.4. = as.factor(TrendType.4.))
df2 <- df %>%
  pivot_longer(cols = c(Genre1, Genre2, Genre3), names_to = "GenreCat", values_to = "Genre") %>%
  select(-GenreCat) %>%
  mutate(Genre = as.character(Genre)) %>%
  filter(Genre != "NaN") %>%
  droplevels() %>%
  mutate(score = 1)
 
(genres <- df2 %>% pull(Genre) %>% unique())

genre_list <- rep(0, length(genres))
names(genre_list) <- genres
(genre_list <- as.list(genre_list))

# With df3, we have created a new table where genres are encoded with dummy variables (0/1)
# A movie appears once, but can be assigned to several genres!
df3 <- df2 %>%
  pivot_wider(names_from = Genre, values_from = score) %>%
  replace_na(genre_list)
 
#Look at the effect of different genres
# For cognition:
glm_cog <- glm(CogCluster ~ 1 + Crime + Drama + Action + War + Thriller + Mystery + 
                            SciFi + Adventure + Comedy + Romance + Fantasy + Horror,
               data = df3, family = binomial(link = "logit"))
glm_cog_wt_const <- glm(CogCluster ~ Crime + Drama + Action + War + Thriller + Mystery + 
                 SciFi + Adventure + Comedy + Romance + Fantasy + Horror,
               data = df3, family = binomial(link = "logit"))
glm_cog_wt_crime = glm(CogCluster ~ 1  + Drama + Action + War + Thriller + Mystery + 
                         SciFi + Adventure + Comedy + Romance + Fantasy + Horror,
                       data = df3, family = binomial(link = "logit"))
glm_cog_wt_drama = glm(CogCluster ~ 1  + Crime + Action + War + Thriller + Mystery + 
                         SciFi + Adventure + Comedy + Romance + Fantasy + Horror,
                       data = df3, family = binomial(link = "logit"))
glm_cog_wt_action = glm(CogCluster ~ 1  + Crime + Drama + War + Thriller + Mystery + 
                         SciFi + Adventure + Comedy + Romance + Fantasy + Horror,
                       data = df3, family = binomial(link = "logit"))
glm_cog_wt_war = glm(CogCluster ~ 1  + Crime + Drama + Action + Thriller + Mystery + 
                          SciFi + Adventure + Comedy + Romance + Fantasy + Horror,
                        data = df3, family = binomial(link = "logit"))c
glm_cog_wt_thrill <- glm(CogCluster ~ 1 + Crime + Drama + Action + War + Mystery + 
                 SciFi + Adventure + Comedy + Romance + Fantasy + Horror,
               data = df3, family = binomial(link = "logit"))
glm_cog_wt_myst <- glm(CogCluster ~ 1 + Crime + Drama + Action + War + Thriller + 
                           SciFi + Adventure + Comedy + Romance + Fantasy + Horror,
                         data = df3, family = binomial(link = "logit"))
glm_cog_wt_scifi <- glm(CogCluster ~ 1 + Crime + Drama + Action + War + Thriller + 
                          Mystery + Adventure + Comedy + Romance + Fantasy + Horror,
                       data = df3, family = binomial(link = "logit"))
glm_cog_wt_adv <- glm(CogCluster ~ 1 + Crime + Drama + Action + War + Thriller + 
                          Mystery + SciFi + Comedy + Romance + Fantasy + Horror,
                        data = df3, family = binomial(link = "logit"))
glm_cog_wt_come <- glm(CogCluster ~ 1 + Crime + Drama + Action + War + Thriller + 
                        Mystery + SciFi + Adventure + Romance + Fantasy + Horror,
                      data = df3, family = binomial(link = "logit"))
glm_cog_wt_romance <- glm(CogCluster ~ 1 + Crime + Drama + Action + War + Thriller + 
                         Mystery + SciFi + Adventure + Comedy + Fantasy + Horror,
                       data = df3, family = binomial(link = "logit"))
glm_cog_wt_fanta <- glm(CogCluster ~ 1 + Crime + Drama + Action + War + Thriller + 
                            Mystery + SciFi + Adventure + Comedy + Romance + Horror,
                          data = df3, family = binomial(link = "logit"))
glm_cog_wt_horror <- glm(CogCluster ~ 1 + Crime + Drama + Action + War + Thriller + 
                          Mystery + SciFi + Adventure + Comedy + Romance + Fantasy,
                        data = df3, family = binomial(link = "logit"))
summary(glm_cog)

# Here, positive values corresponds to the direction of decreasing cognition, 
#and negative values to the direction of increasing cognition

#Next, we are looking at the logistic regression on Emo Clusters
glm_emo <- glm(EmoCluster ~ 1 + Crime + Drama + Action + War + Thriller + Mystery + 
                            SciFi + Adventure + Comedy + Romance + Fantasy + Horror,
               data = df3, family = binomial(link = "logit"))
summary(glm_emo)
glm_emo_wt_crime = glm(EmoCluster ~ 1  + Drama + Action + War + Thriller + Mystery + 
                         SciFi + Adventure + Comedy + Romance + Fantasy + Horror,
                       data = df3, family = binomial(link = "logit"))
glm_emo_wt_drama = glm(EmoCluster ~ 1  + Crime + Action + War + Thriller + Mystery + 
                         SciFi + Adventure + Comedy + Romance + Fantasy + Horror,
                       data = df3, family = binomial(link = "logit"))
glm_emo_wt_action = glm(EmoCluster ~ 1  + Crime + Drama + War + Thriller + Mystery + 
                          SciFi + Adventure + Comedy + Romance + Fantasy + Horror,
                        data = df3, family = binomial(link = "logit"))
glm_emo_wt_war = glm(EmoCluster ~ 1  + Crime + Drama + Action + Thriller + Mystery + 
                       SciFi + Adventure + Comedy + Romance + Fantasy + Horror,
                     data = df3, family = binomial(link = "logit"))
glm_emo_wt_thrill <- glm(EmoCluster ~ 1 + Crime + Drama + Action + War + Mystery + 
                           SciFi + Adventure + Comedy + Romance + Fantasy + Horror,
                         data = df3, family = binomial(link = "logit"))
glm_emo_wt_myst <- glm(EmoCluster ~ 1 + Crime + Drama + Action + War + Thriller + 
                         SciFi + Adventure + Comedy + Romance + Fantasy + Horror,
                       data = df3, family = binomial(link = "logit"))
glm_emo_wt_scifi <- glm(EmoCluster ~ 1 + Crime + Drama + Action + War + Thriller + 
                          Mystery + Adventure + Comedy + Romance + Fantasy + Horror,
                        data = df3, family = binomial(link = "logit"))
glm_emo_wt_adv <- glm(EmoCluster ~ 1 + Crime + Drama + Action + War + Thriller + 
                        Mystery + SciFi + Comedy + Romance + Fantasy + Horror,
                      data = df3, family = binomial(link = "logit"))
glm_emo_wt_come <- glm(EmoCluster ~ 1 + Crime + Drama + Action + War + Thriller + 
                         Mystery + SciFi + Adventure + Romance + Fantasy + Horror,
                       data = df3, family = binomial(link = "logit"))
glm_emo_wt_romance <- glm(EmoCluster ~ 1 + Crime + Drama + Action + War + Thriller + 
                            Mystery + SciFi + Adventure + Comedy + Fantasy + Horror,
                          data = df3, family = binomial(link = "logit"))
glm_emo_wt_fanta <- glm(EmoCluster ~ 1 + Crime + Drama + Action + War + Thriller + 
                          Mystery + SciFi + Adventure + Comedy + Romance + Horror,
                        data = df3, family = binomial(link = "logit"))
glm_emo_wt_horror <- glm(EmoCluster ~ 1 + Crime + Drama + Action + War + Thriller + 
                           Mystery + SciFi + Adventure + Comedy + Romance + Fantasy,
                         data = df3, family = binomial(link = "logit"))
                         
                         
# Adding age and Tencent scores of the movies
# For CogClusters
glm_cog_age_score <- glm(CogCluster ~ 1 + MovieAge + TencentScores +
                                      Crime + Drama + Action + War + Thriller + Mystery + 
                                      SciFi + Adventure + Comedy + Romance + Fantasy + Horror,
                          data = df3, family = binomial(link = "logit"))
glm_cog_age_score_wt_crime = glm(CogCluster ~ 1 + MovieAge + TencentScores + Drama + Action + War + Thriller + Mystery + 
                         SciFi + Adventure + Comedy + Romance + Fantasy + Horror,
                       data = df3, family = binomial(link = "logit"))
glm_cog_age_score_wt_drama = glm(CogCluster ~ 1 + MovieAge + TencentScores + Crime + Action + War + Thriller + Mystery + 
                         SciFi + Adventure + Comedy + Romance + Fantasy + Horror,
                       data = df3, family = binomial(link = "logit"))
glm_cog_age_score_wt_action = glm(CogCluster ~ 1 + MovieAge + TencentScores + Crime + Drama + War + Thriller + Mystery + 
                          SciFi + Adventure + Comedy + Romance + Fantasy + Horror,
                        data = df3, family = binomial(link = "logit"))
glm_cog_age_score_wt_war = glm(CogCluster ~ 1 + MovieAge + TencentScores + Crime + Drama + Action + Thriller + Mystery + 
                       SciFi + Adventure + Comedy + Romance + Fantasy + Horror,
                     data = df3, family = binomial(link = "logit"))
glm_cog_age_score_wt_thrill <- glm(CogCluster ~ 1+ MovieAge + TencentScores + Crime + Drama + Action + War + Mystery + 
                           SciFi + Adventure + Comedy + Romance + Fantasy + Horror,
                         data = df3, family = binomial(link = "logit"))
glm_cog_age_score_wt_myst <- glm(CogCluster ~ 1+ MovieAge + TencentScores + Crime + Drama + Action + War + Thriller + 
                         SciFi + Adventure + Comedy + Romance + Fantasy + Horror,
                       data = df3, family = binomial(link = "logit"))
glm_cog_age_score_wt_scifi <- glm(CogCluster ~ 1+ MovieAge + TencentScores + Crime + Drama + Action + War + Thriller + 
                          Mystery + Adventure + Comedy + Romance + Fantasy + Horror,
                        data = df3, family = binomial(link = "logit"))
glm_cog_age_score_wt_adv <- glm(CogCluster ~ 1+ MovieAge + TencentScores + Crime + Drama + Action + War + Thriller + 
                        Mystery + SciFi + Comedy + Romance + Fantasy + Horror,
                      data = df3, family = binomial(link = "logit"))
glm_cog_age_score_wt_come <- glm(CogCluster ~ 1+ MovieAge + TencentScores + Crime + Drama + Action + War + Thriller + 
                         Mystery + SciFi + Adventure + Romance + Fantasy + Horror,
                       data = df3, family = binomial(link = "logit"))
glm_cog_age_score_wt_romance <- glm(CogCluster ~ 1+ MovieAge + TencentScores + Crime + Drama + Action + War + Thriller + 
                            Mystery + SciFi + Adventure + Comedy + Fantasy + Horror,
                          data = df3, family = binomial(link = "logit"))
glm_cog_age_score_wt_fanta <- glm(CogCluster ~ 1 + MovieAge + TencentScores+ Crime + Drama + Action + War + Thriller + 
                          Mystery + SciFi + Adventure + Comedy + Romance + Horror,
                        data = df3, family = binomial(link = "logit"))
glm_cog_age_score_wt_horror <- glm(CogCluster ~ 1 + MovieAge + TencentScores+ Crime + Drama + Action + War + Thriller + 
                           Mystery + SciFi + Adventure + Comedy + Romance + Fantasy,
                         data = df3, family = binomial(link = "logit"))
glm_cog_age_score_wt_age <- glm(CogCluster ~ 1  + TencentScores +
                                  Crime + Drama + Action + War + Thriller + Mystery + 
                                  SciFi + Adventure + Comedy + Romance + Fantasy + Horror,
                                data = df3, family = binomial(link = "logit"))
glm_cog_age_score_wt_score <- glm(CogCluster ~ 1 + MovieAge  +
                                    Crime + Drama + Action + War + Thriller + Mystery + 
                                    SciFi + Adventure + Comedy + Romance + Fantasy + Horror,
                                  data = df3, family = binomial(link = "logit"))
                                
                          
# Adding age and Tencent scores of the movies
# For CogClusters                               
glm_emo_age_score <- glm(EmoCluster ~ 1 + MovieAge + TencentScores +
                                      Crime + Drama + Action + War + Thriller + Mystery + 
                                      SciFi + Adventure + Comedy + Romance + Fantasy + Horror,
                         data = df3, family = binomial(link = "logit"))
glm_emo_age_score_wt_crime = glm(EmoCluster ~ 1 + MovieAge + TencentScores + Drama + Action + War + Thriller + Mystery + 
                                   SciFi + Adventure + Comedy + Romance + Fantasy + Horror,
                                 data = df3, family = binomial(link = "logit"))
glm_emo_age_score_wt_drama = glm(EmoCluster ~ 1 + MovieAge + TencentScores + Crime + Action + War + Thriller + Mystery + 
                                   SciFi + Adventure + Comedy + Romance + Fantasy + Horror,
                                 data = df3, family = binomial(link = "logit"))
glm_emo_age_score_wt_action = glm(EmoCluster ~ 1 + MovieAge + TencentScores + Crime + Drama + War + Thriller + Mystery + 
                                    SciFi + Adventure + Comedy + Romance + Fantasy + Horror,
                                  data = df3, family = binomial(link = "logit"))
glm_emo_age_score_wt_war = glm(EmoCluster ~ 1 + MovieAge + TencentScores + Crime + Drama + Action + Thriller + Mystery + 
                                 SciFi + Adventure + Comedy + Romance + Fantasy + Horror,
                               data = df3, family = binomial(link = "logit"))
glm_emo_age_score_wt_thrill <- glm(EmoCluster ~ 1+ MovieAge + TencentScores + Crime + Drama + Action + War + Mystery + 
                                     SciFi + Adventure + Comedy + Romance + Fantasy + Horror,
                                   data = df3, family = binomial(link = "logit"))
glm_emo_age_score_wt_myst <- glm(EmoCluster ~ 1+ MovieAge + TencentScores + Crime + Drama + Action + War + Thriller + 
                                   SciFi + Adventure + Comedy + Romance + Fantasy + Horror,
                                 data = df3, family = binomial(link = "logit"))
glm_emo_age_score_wt_scifi <- glm(EmoCluster ~ 1+ MovieAge + TencentScores + Crime + Drama + Action + War + Thriller + 
                                    Mystery + Adventure + Comedy + Romance + Fantasy + Horror,
                                  data = df3, family = binomial(link = "logit"))
glm_emo_age_score_wt_adv <- glm(EmoCluster ~ 1+ MovieAge + TencentScores + Crime + Drama + Action + War + Thriller + 
                                  Mystery + SciFi + Comedy + Romance + Fantasy + Horror,
                                data = df3, family = binomial(link = "logit"))
glm_emo_age_score_wt_come <- glm(EmoCluster ~ 1+ MovieAge + TencentScores + Crime + Drama + Action + War + Thriller + 
                                   Mystery + SciFi + Adventure + Romance + Fantasy + Horror,
                                 data = df3, family = binomial(link = "logit"))
glm_emo_age_score_wt_romance <- glm(EmoCluster ~ 1+ MovieAge + TencentScores + Crime + Drama + Action + War + Thriller + 
                                      Mystery + SciFi + Adventure + Comedy + Fantasy + Horror,
                                    data = df3, family = binomial(link = "logit"))
glm_emo_age_score_wt_fanta <- glm(EmoCluster ~ 1 + MovieAge + TencentScores+ Crime + Drama + Action + War + Thriller + 
                                    Mystery + SciFi + Adventure + Comedy + Romance + Horror,
                                  data = df3, family = binomial(link = "logit"))
glm_emo_age_score_wt_horror <- glm(EmoCluster ~ 1 + MovieAge + TencentScores+ Crime + Drama + Action + War + Thriller + 
                                     Mystery + SciFi + Adventure + Comedy + Romance + Fantasy,
                                   data = df3, family = binomial(link = "logit"))
glm_emo_age_score_wt_age <- glm(EmoCluster ~ 1  + TencentScores +
                                  Crime + Drama + Action + War + Thriller + Mystery + 
                                  SciFi + Adventure + Comedy + Romance + Fantasy + Horror,
                                data = df3, family = binomial(link = "logit"))
glm_emo_age_score_wt_score <- glm(EmoCluster ~ 1 + MovieAge  +
                                    Crime + Drama + Action + War + Thriller + Mystery + 
                                    SciFi + Adventure + Comedy + Romance + Fantasy + Horror,
                                  data = df3, family = binomial(link = "logit"))

