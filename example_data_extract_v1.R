library(dplyr)
library(tidyr)
library(reshape2)
setwd('~/Data/Dropbox/MANUSCRIPTS/BNL_TEST/Serbin_Global_Spec-LMA_Analysis/R_Scripts/curate_data/')
list.files()
specdb <- src_sqlite('leaf_spectra.db')

test_samples <- tbl(specdb, 'samples') %>% filter(projectcode == 'wu_brazil') %>% inner_join(tbl(specdb, 'trait_data')) %>% collect

spec <- tbl(specdb, 'samples') %>%
  filter(projectcode == 'wu_brazil') %>%
  inner_join(tbl(specdb, 'spectra_info')) %>%
  inner_join(tbl(specdb, 'spectra_data')) %>%
  collect(n = Inf)

spec_trait <- tbl(specdb, 'samples') %>%
  filter(projectcode == 'wu_brazil') %>%
  inner_join(tbl(specdb, 'trait_data')) %>%
  inner_join(tbl(specdb, 'spectra_info')) %>%
  inner_join(tbl(specdb, 'spectra_data')) %>%
  collect(n = Inf)



test_samples <- tbl(specdb, 'samples') %>% filter(projectcode == 'wu_b2') %>% inner_join(tbl(specdb, 'trait_data')) %>% collect

spec <- tbl(specdb, 'samples') %>%
  filter(projectcode == 'wu_b2') %>%
  inner_join(tbl(specdb, 'spectra_info')) %>%
  inner_join(tbl(specdb, 'spectra_data')) %>%
  collect(n = Inf)







data_wide <- spread(olddata_long, condition, measurement)

temp <- data.frame(spec$sampleid,spec$wavelength,spec$spectravalue)
temp2 <- t(temp)

temp2 <- as.data.frame(t(temp))






#spec2 <- t(spec)
#spec <- as.data.frame(spec)
#spec2 <- melt(spec,id=c("sampleid","spectraid"), value.name = "spectravalue")
#spec2 <- melt(spec, varnames = dimnames(spec)[[2]], value.name = "spectravalue")
#spec2 <-melt(spec, varnames = c("sampleid", "samplecode","spectraid"), value.name = "spectravalue")
#spec2 <- dcast(melt(spec), variable~spectraid)

spec2 <- spec %>%
  spread(sampleid,spectraid)

spec2 <- spec %>%
  spread(wavelength,spectravalue)


spread(spec,key="wavelength")



