time_resolution <- 5 # min
spatial_resolution <- 0.3225 # to convert pixels to µm
cross_section <- 98 # µm^2 area of channels

data <- read.csv2 ('131031_results.csv')

# pour calculer delta-t (cell cycle length), delta-V et deltaV/delta-t taux de croissance des deux cellules filles
data$ccl_big  <- (data$Time.bf - data$Time.bi) * time_resolution
data$ccl_small  <- (data$Time.sf - data$Time.si) * time_resolution
data$volgained_big <- (data$Vol.bf - data$Vol.bi) * cross_section
data$volgained_small <- (data$Vol.sf - data$Vol.si) * cross_section
data$GR_big <- (data$volgained_big / data$ccl_big)
data$GR_small <- (data$volgained_small / data$ccl_small)

# comparaison delta-t et delta-V et GR entre les paires de cellules filles
data$delta_volgained <- (data$volgained_big - data$volgained_small)
data$delta_ccl <- (data$ccl_big - data$ccl_small)
data$delta_GR <- (data$GR_big - data$GR_small)

# plots comparaison des cellules filles
data$zero <- (data$ccl_big - data$ccl_big) #coordonnées xo, yo du vecteur
## DV et DT
plot ( x = data$delta_ccl, 
       y = data$delta_volgained,
       xlab = "delta cell cycle length big-small sister",
       ylab = "delta volume gained big-small sister",
       type = "n")
arrows (data$zero, data$zero, data$delta_ccl, 
        data$delta_volgained, 
        length = 0.1, 
        angle = 45,
        col = data$MotherVol.b)

## DV et DGR
plot ( x = data$delta_GR, 
       y = data$delta_volgained,
       xlab = "delta GR big-small sister",
       ylab = "delta volume gained big-small sister",
       type = "n")
arrows (data$zero, data$zero, data$delta_GR, 
        data$delta_volgained, 
        length = 0.1, 
        angle = 45,
        col = rainbow (length(data$MotherVol.b))[rank(data$MotherVol.b)])
# ou col = data$MotherVol.b

## pour essayer avec ggplot2
library(ggplot2)
ggplot(data=data, aes(x = data$delta_ccl, 
                      y = data$delta_volgained, 
                      col = data$MotherVol.b,y=y,col=fact)) + geom_point()

