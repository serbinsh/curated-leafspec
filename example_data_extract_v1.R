library(dplyr)
specdb <- src_sqlite('leaf_spectra')
test_samples <- tbl(specdb, 'samples') %>% filter(projectcode == 'wu_brazil') %>% inner_join(tbl(specdb, 'trait_data')) %>% collect

test_spectra <- tbl(specdb, 'samples') %>% filter(projectcode == 'wu_brazil') %>% inner_join(tbl(specdb, 'spectra_data'), by='spectradataid') %>% collect
