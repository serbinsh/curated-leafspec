library(specprocess)
library(RSQLite)
setwd('~/Data/Dropbox/MANUSCRIPTS/BNL_TEST/Serbin_Global_Spec-LMA_Analysis/R_Scripts/curate_data/')

specdb <- src_sqlite('leaf_spectra.db')
projects <- read_csv('data/common/projects.csv')
mrg <- db_merge_into(db = specdb, table = 'projects', values = projects,
                     by = 'projectcode', id_colname = 'projectid')

tbl(specdb, 'projects')
data.frame(tbl(specdb, 'projects'))