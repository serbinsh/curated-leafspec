library(specprocess)
source('common.R')

datapath <- '~/Data/Dropbox/MANUSCRIPTS/BNL_TEST/Serbin_Global_Spec-LMA_Analysis/Data'
projectcode <- "nasa_hyspiri"

projects <- tibble(projectcode = 'nasa_hyspiri',
                   projectdescription = 'NASA HyspIRI field campaign',
                   pointofcontact = 'Serbin, Shawn',
                   email = 'sserbin@bnl.gov') %>%
  db_merge_into(db = specdb, table = 'projects', values = .,
                by = 'projectcode', id_colname = 'projectid')

#' Set names for fixing
names_samples <- c("Sample_Name" = "SampleName",
                   "Sample_Year" = "year",
                   "Height" = "CanopyPosition",
                   'Site' = 'sitecode',
                   'Plot' = 'plotcode',
                   'Species' = 'speciesdatacode')

names_specInfo <- c("Instrumentation" = "Instrument",
                    "Measurement_Type" = "Apparatus",
                    "Measurement" = "SpectraType")


#' Load reflectance data 
PATH.refl <- file.path(datapath, "Spectra/NASA_HyspIRI/NASA_HyspIRI_Spectra_and_LMA_subset.csv")
nasa_hyspiri_refl <- fread(PATH.refl, header=TRUE) %>%
  mutate(projectcode = projectcode,
         samplecode = paste(projectcode, Spectra, Measurement_Date,
                            sep = '|')) %>%
  setnames(names(names_all), names_all)




samples_refl <- select(nasa_fft.all_refl, -starts_with('Wave_'))

spectra_refl <- select(nasa_fft.all_refl, samplecode, starts_with('Wave_')) %>%
  melt(id.vars = 'samplecode', value.name = 'spectravalue') %>%
  mutate(wavelength = as.numeric(gsub('Wave_', '', variable))) %>%
  select(-variable)
spectra_info_refl <- distinct(spectra_refl, samplecode) %>%
  mutate(spectratype = 'reflectance')