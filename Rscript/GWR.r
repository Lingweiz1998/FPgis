## setting up the data!

nyfc <- read_csv(here::here("data", "rawdata","facilities_201912csv","facilities_201912.csv"),
                 na = c("", "NA", "n/a"), 
                 locale = locale(encoding = 'utf-8'), 
                 col_names = TRUE)

colnames(nyfc) <- colnames(nyfc) %>% 
  str_to_lower() %>% 
  str_replace_all(" ", "_")
#check all of the columns have been read in correctly
Datatypelist <- nyfc %>% 
  summarise_all(class) %>%
  pivot_longer(everything(), 
               names_to="All_variables", 
               values_to="Variable_class")
Datatypelist
#select necessary rows
nyfc1 <- nyfc %>% 
  dplyr::select(factype,facsubgrp,facgroup,facdomain,latitude,longitude)
# remove na in r - remove rows - na.omit function / option
nyfc1 <- na.omit(nyfc1)
# change to spatial data frame
nyfc1 <- st_as_sf(nyfc1, coords = c("longitude", "latitude"), crs = "WGS84")
nyfc1 <- nyfc1 %>% 
  st_transform(.,crs="epsg:2263")
nyfc1 <- nyfc1[CDMap1boro,]

# making density map to standardize the variables.
fc_edu <- nyfc1 %>%  
  filter(facdomain == "EDUCATION, CHILD WELFARE, AND YOUTH" )
fc_heal <- nyfc1 %>%  
  filter(facdomain == "HEALTH AND HUMAN SERVICES" )
fc_park <- nyfc1 %>%  
  filter(facdomain == "PARKS, GARDENS, AND HISTORICAL SITES" )
fc_tran <- nyfc1 %>%  
  filter(facdomain == "CORE INFRASTRUCTURE AND TRANSPORTATION" )
fc_admin <- nyfc1 %>%  
  filter(facdomain == "ADMINISTRATION OF GOVERNMENT" )
fc_publi <- nyfc1 %>%  
  filter(facdomain == "PUBLIC SAFETY, EMERGENCY SERVICES, AND ADMINISTRATION OF JUSTICE" )
fc_lib <- nyfc1 %>%  
  filter(facdomain == "LIBRARIES AND CULTURAL PROGRAMS" )
## edu file
gwrfc_edu <- CDMap1boro%>%
  st_join(fc_edu)%>%
  add_count(borocd)%>%
  janitor::clean_names()%>%
  mutate(area=st_area(.))%>%
  mutate(density=n/area)%>%
  dplyr::select(density, borocd, n)
gwrfc_edu<- gwrfc_edu %>%                    
  group_by(borocd) %>%         
  summarise(density_edu = first(density),
            borocd= first(borocd),
            count_edu= first(n))
gwrfc_edu<- gwrfc_edu %>%
  st_drop_geometry()
gwrfc_edu$density_edu_scaled <- scale(gwrfc_edu$density_edu,center = FALSE, scale = TRUE)
  
## heal file
gwrfc_heal <- CDMap1boro%>%
  st_join(fc_heal)%>%
  add_count(borocd)%>%
  janitor::clean_names()%>%
  mutate(area=st_area(.))%>%
  mutate(density=n/area)%>%
  dplyr::select(density, borocd, n)
gwrfc_heal<- gwrfc_heal %>%                    
  group_by(borocd) %>%         
  summarise(density_heal = first(density),
            borocd= first(borocd),
            count_heal= first(n))
gwrfc_heal<- gwrfc_heal %>%
  st_drop_geometry()
gwrfc_heal$density_heal_scaled <- scale(gwrfc_heal$density_heal,center = FALSE, scale = TRUE)

## tans file
gwrfc_tran <- CDMap1boro%>%
  st_join(fc_tran)%>%
  add_count(borocd)%>%
  janitor::clean_names()%>%
  mutate(area=st_area(.))%>%
  mutate(density=n/area)%>%
  dplyr::select(density, borocd, n)
gwrfc_tran<- gwrfc_tran %>%                    
  group_by(borocd) %>%         
  summarise(density_tran = first(density),
            borocd= first(borocd),
            count_tran= first(n))
gwrfc_tran<- gwrfc_tran %>%
  st_drop_geometry()
gwrfc_tran$density_tran_scaled <- scale(gwrfc_tran$density_tran,center = FALSE, scale = TRUE)

## park file
gwrfc_park <- CDMap1boro%>%
  st_join(fc_park)%>%
  add_count(borocd)%>%
  janitor::clean_names()%>%
  mutate(area=st_area(.))%>%
  mutate(density=n/area)%>%
  dplyr::select(density, borocd, n)
gwrfc_park<- gwrfc_park %>%                    
  group_by(borocd) %>%         
  summarise(density_park = first(density),
            borocd= first(borocd),
            count_park= first(n))
gwrfc_park<- gwrfc_park %>%
  st_drop_geometry()
gwrfc_park$density_park_scaled <- scale(gwrfc_park$density_park,center = FALSE, scale = TRUE)


## admin file
gwrfc_admin <- CDMap1boro%>%
  st_join(fc_admin)%>%
  add_count(borocd)%>%
  janitor::clean_names()%>%
  mutate(area=st_area(.))%>%
  mutate(density=n/area)%>%
  dplyr::select(density, borocd, n)
gwrfc_admin<- gwrfc_admin %>%                    
  group_by(borocd) %>%         
  summarise(density_admin = first(density),
            borocd= first(borocd),
            count_admin= first(n))
gwrfc_admin<- gwrfc_admin %>%
  st_drop_geometry()
gwrfc_admin$density_admin_scaled <- scale(gwrfc_admin$density_admin,center = FALSE, scale = TRUE)

## public file
gwrfc_publi <- CDMap1boro%>%
  st_join(fc_publi)%>%
  add_count(borocd)%>%
  janitor::clean_names()%>%
  mutate(area=st_area(.))%>%
  mutate(density=n/area)%>%
  dplyr::select(density, borocd, n)
gwrfc_publi<- gwrfc_publi %>%                    
  group_by(borocd) %>%         
  summarise(density_publi = first(density),
            borocd= first(borocd),
            count_publi= first(n))
gwrfc_publi<- gwrfc_publi %>%
  st_drop_geometry()
gwrfc_publi$density_publi_scaled <- scale(gwrfc_publi$density_publi,center = FALSE, scale = TRUE)


## library file
gwrfc_lib <- CDMap1boro%>%
  st_join(fc_lib)%>%
  add_count(borocd)%>%
  janitor::clean_names()%>%
  mutate(area=st_area(.))%>%
  mutate(density=n/area)%>%
  dplyr::select(density, borocd, n)
gwrfc_lib<- gwrfc_lib %>%                    
  group_by(borocd) %>%         
  summarise(density_lib = first(density),
            borocd= first(borocd),
            count_lib= first(n))
gwrfc_lib<- gwrfc_lib %>%
  st_drop_geometry()
gwrfc_lib$density_lib_scaled <- scale(gwrfc_lib$density_lib,center = FALSE, scale = TRUE)

## join all data
gwrfc <- points_sf_joined%>%
  left_join(.,
            gwrfc_edu, 
            by = c("borocd" = "borocd"))
gwrfc <- gwrfc%>%
  left_join(.,
            gwrfc_heal, 
            by = c("borocd" = "borocd"))
gwrfc <- gwrfc%>%
  left_join(.,
            gwrfc_tran, 
            by = c("borocd" = "borocd"))
gwrfc <- gwrfc%>%
  left_join(.,
            gwrfc_park, 
            by = c("borocd" = "borocd"))
gwrfc <- gwrfc%>%
  left_join(.,
            gwrfc_publi, 
            by = c("borocd" = "borocd"))
gwrfc <- gwrfc%>%
  left_join(.,
            gwrfc_admin, 
            by = c("borocd" = "borocd"))
gwrfc <- gwrfc%>%
  left_join(.,
            gwrfc_lib, 
            by = c("borocd" = "borocd"))
colnames(gwrfc)

# plot each map
tmap_mode("plot")
tm1 <- tm_shape(gwrfc) + 
  tm_polygons("density_edu", 
              palette="PuBu")+
  tm_legend(show=FALSE)+
  tm_layout(frame=FALSE)+
  tm_credits("(a)", position=c(0,0.85), size=1.5)

tm2 <- tm_shape(gwrfc) + 
  tm_polygons("density_heal",
              palette="PuBu") + 
  tm_legend(show=FALSE)+
  tm_layout(frame=FALSE)+
  tm_credits("(b)", position=c(0,0.85), size=1.5)
tm3 <- tm_shape(gwrfc) + 
  tm_polygons("density_tran",
              palette="PuBu") + 
  tm_legend(show=FALSE)+
  tm_layout(frame=FALSE)+
  tm_credits("(c)", position=c(0,0.85), size=1.5)
tm4 <- tm_shape(gwrfc)+ 
  tm_polygons("density_park", 
              palette="PuBu")+
  tm_legend(show=FALSE)+
  tm_layout(frame=FALSE)+
  tm_credits("(d)", position=c(0,0.85), size=1.5)

tm5 <- tm_shape(gwrfc)+ 
  tm_polygons("density_publi", 
              palette="PuBu")+
  tm_legend(show=FALSE)+
  tm_layout(frame=FALSE)+
  tm_credits("(e)", position=c(0,0.85), size=1.5)

tm6 <- tm_shape(gwrfc)+ 
  tm_polygons("density_admin", 
              palette="PuBu")+
  tm_legend(show=FALSE)+
  tm_layout(frame=FALSE)+
  tm_credits("(f)", position=c(0,0.85), size=1.5)

tm7 <- tm_shape(gwrfc)+ 
  tm_polygons("density_lib", 
              palette="PuBu")+
  tm_legend(show=FALSE)+
  tm_layout(frame=FALSE)+
  tm_credits("(g)", position=c(0,0.85), size=1.5)

legend <- tm_shape(gwrfc) +
  tm_polygons("density_park",
              palette="PuBu",
              title = "Density of Facilities") +
  tm_scale_bar(position=c(0.2,0.04), text.size=0.6)+
  tm_compass(north=0, position=c(0.025,0.4))+
  tm_layout(legend.only = TRUE, legend.position=c(0.2,0.25),asp=0.1)

t=tmap_arrange(tm1, tm2, tm3,tm4,tm5,tm6,tm7, legend, ncol=4)

t

#plot with a regression line - note, I've added some jitter here as the x-scale is rounded
q <- qplot(x = `density_tran_scaled`, 
           y = `density_scaled`, 
           data=gwrfc)
q + stat_smooth(method="lm", se=FALSE, size=1) + 
  geom_jitter()

#histogram plot
'''
symbox(~density_scaled, 
       gwrfc, 
       na.rm=T,
       powers=seq(-3,3,by=.5))

ggplot(gwrfc, aes((x=density_scaled)^-1)) + 
  geom_histogram(aes(y = ..density..),
                 binwidth = 50) + 
  geom_density(colour="red", 
               size=1, 
               adjust=1)
'''
### GWRRRRR!
#select some variables from the data file
gwrfc_1 <- gwrfc %>%
  dplyr::select(density_scaled,
                density_edu_scaled,
                density_heal_scaled,
                density_tran_scaled,
                density_park_scaled,
                density_publi_scaled,
                density_admin_scaled,
                density_lib_scaled)
'''
#check their correlations are OK
Correlation_myvars <- myvars %>%
  st_drop_geometry()%>%
  correlate()
'''
#run a final OLS model
model_final <- lm(density_scaled ~  
                  density_edu_scaled+
                  density_heal_scaled+
                  density_tran_scaled+
                  density_park_scaled+
                  density_admin_scaled,
                  data = gwrfc_1)
vif(model_final)
tidy(model_final)
summary(model_final)
glance(model_final)
anova(model_final)
AICc(model_final)

##residuals
model_data <- model_final %>%
  augment(., gwrfc_1)
#plot residuals
model_data%>%
  dplyr::select(.resid)%>%
  pull()%>%
  qplot()+ 
  geom_histogram(binwidth = 0.01) 

gwrfc_1 <- gwrfc_1 %>%
  mutate(modelOLSresids = residuals(model_final))

#print some model diagnositcs. 
par(mfrow=c(2,2))    #plot to 2 by 2 array
plot(model_final)

#now plot the residuals
tmap_mode("view")
qtm(gwrfc_1, fill = "modelOLSresids")

#knn
knn_nyccd <-coordsW %>%
  knearneigh(., k=4)
nyccd_knn <- knn_nyccd %>%
  knn2nb()
nyccd_knn_weight <- nyccd_knn %>%
  nb2listw(., style="C")
#queen
nyccd_nb_weight <- nyccd_nb %>%
  nb2listw(., style="C")

Queen  <- gwrfc_1 %>%
  st_drop_geometry()%>%
  dplyr::select(modelOLSresids)%>%
  pull()%>%
  moran.test(., nyccd_nb_weight)%>%
  tidy()
Nearest_neighbour <- gwrfc_1 %>%
  st_drop_geometry()%>%
  dplyr::select(modelOLSresids)%>%
  pull()%>%
  moran.test(., nyccd_knn_weight)%>%
  tidy()
Queen 
Nearest_neighbour
#spatial lag regre
model_final2queen <- lagsarlm(density_scaled ~  
                                density_edu_scaled+
                                density_heal_scaled+
                                density_tran_scaled+
                                density_park_scaled+
                                density_admin_scaled,
                                data = gwrfc_1, 
                                nb2listw(nyccd_nb, style="C"), 
                                method = "eigen")
tidy(model_final2queen)
summary(model_final2queen)
glance(model_final2queen)
anova(model_final2queen)
AICc(model_final2queen)

gwrfc_1 <- gwrfc_1 %>%
  mutate(slag_dv_model2_queen_resids = residuals(model_final2queen))
queenMoran <- gwrfc_1 %>%
  st_drop_geometry()%>%
  dplyr::select(slag_dv_model2_queen_resids)%>%
  pull()%>%
  moran.test(., nyccd_nb_weight)%>%
  tidy()
queenMoran

#spatial error regre
model_final3 <- errorsarlm(density_scaled ~  
                             density_edu_scaled+
                             density_heal_scaled+
                             density_tran_scaled+
                             density_park_scaled+
                             density_admin_scaled,
                           data = gwrfc_1, 
                         nb2listw(nyccd_nb, style="C"), 
                         method = "eigen")
tidy(model_final3)
summary(model_final3)
glance(model_final3)
anova(model_final3)
AICc(model_final3)

gwrfc_1 <- gwrfc_1 %>%
  mutate(ser_dv_model3_queen_resids = residuals(model_final3))
queenMoran2 <- gwrfc_1 %>%
  st_drop_geometry()%>%
  dplyr::select(ser_dv_model3_queen_resids)%>%
  pull()%>%
  moran.test(., nyccd_nb_weight)%>%
  tidy()
queenMoran2

#now plot the residuals
tmap_mode("view")
qtm(gwrfc_1, fill = "ser_dv_model3_queen_resids")
