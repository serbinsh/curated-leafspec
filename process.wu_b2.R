library(specprocess)
source('common.R')

datapath <- '~/Data/Dropbox/MANUSCRIPTS/BNL_TEST/Serbin_Global_Spec-LMA_Analysis/Data'

projects <- tibble(projectcode = 'wu_b2',
                   projectdescription = 'Wu et al. unpublished data',
                   pointofcontact = 'Wu, Jin',
                   email = 'jinwu@bnl.gov',
                   doi = '') %>%
  db_merge_into(db = specdb, table = 'projects', values = .,
                by = 'projectcode', id_colname = 'projectid')

specdata <- read_csv(file.path(datapath, 'Spectra/B2/','B2_ASD_Leaf_Spectra_filter_v1.csv')) %>%
  mutate(wavelength = as.numeric(gsub(' nm', '', Wavelength))) %>%
  select(-Wavelength) %>%
  gather(key = Leaf_Number, value = spectravalue, -wavelength) %>%
  mutate(samplecode = paste(projects$projectcode, Leaf_Number, NA, sep = '|')) %>%
  select(-Leaf_Number)


traitdata <- read_csv(file.path(datapath, 'SLA_LMA_Data/B2/','B2_Trait_Data_filter_v1.csv')) %>%
  mutate(leaf_mass_per_area = 1/SLA_m2_kg,  # TRAIT CONVERSION!
         leaf_water_thickness = Water_Perc * leaf_mass_per_area,
         VegetationType = recode(Vegetation_Type,
                                 `0` = 'B2NTF',
                                 `1` = 'B2TF'),
         samplecode = paste(projects$projectcode, Leaf_Number, NA, sep = '|')) %>%
  select(samplecode, leaf_mass_per_area, leaf_water_thickness,
         VegetationType)

siteplot <- tribble(
  ~sitecode, ~latitude, ~longitude,
  'wu_b2.Biosphere2', (32.5784), (110.8514)) %>%
  mutate(plotcode = sitecode) %>%
  db_merge_into(db = specdb, table = 'sites', values = .,
                by = 'sitecode', id_colname = 'siteid') %>%
  db_merge_into(db = specdb, table = 'plots', values = .,
                by = 'plotcode', id_colname = 'plotid')

# TODO: Fill in missing species

samples <- traitdata %>%
  distinct(samplecode) %>%
  mutate(projectcode = projects$projectcode,
         plotcode = siteplot$plotcode) %>%
  db_merge_into(db = specdb, table = 'samples', values = .,
                by = 'samplecode', id_colname = 'sampleid')

specmethods <- tibble(
  instrumentname = 'ASD FieldSpec Pro',
  minwavelength = 350,
  maxwavelength = 2500,
  instrumentcomment = paste0('1.4nm visible, 2.2nm NIR, 2.3nm SWIR, ',
                             'interpolated to 1nm; Analytical Spectra ',
                             'Devices, ASD, Boulder, CO, USA'),
  calibration = 'Spectralon ratio',
  specmethodcomment = '10.1111/nph.14051') %>%
  db_merge_into(db = specdb, table = 'instruments', values = .,
                by = 'instrumentname', id_colname = 'instrumentid') %>%
  db_merge_into(db = specdb, table = 'specmethods', values = .,
                by = c('instrumentid', 'calibration', 'specmethodcomment'),
                id_colname = 'specmethodid')

spectra_info <- specdata %>%
  distinct(samplecode) %>%
  mutate(specmethodid = specmethods$specmethodid,
         spectratype = 'reflectance') %>%
  db_merge_into(db = specdb, table = 'spectra_info', values = .,
                by = c('samplecode', 'spectratype'), id_colname = 'spectraid')

spectra_data <- specdata %>%
  left_join(spectra_info) %>%
  write_spectradata   

# sample_condition <- traitdata %>%
#   select(samplecode, CompleteLeaf, LeafAge, sunshade) %>%
#   gather(condition, conditionvalue, -samplecode)

# sample_condition_info <- sample_condition %>%
#   distinct(condition) %>%
#   db_merge_into(db = specdb, table = 'sample_condition_info', values = .,
#                 by = 'condition', id_colname = 'conditionid')

# sample_condition <- db_merge_into(db = specdb, table = 'sample_condition',
#                                   values = sample_condition, 
#                                   by = c('samplecode', 'condition'),
#                                   id_colname = 'conditiondataid')


trait_data <- traitdata %>%
  select(samplecode, starts_with('leaf_', ignore.case = FALSE)) %>%
  gather(trait, traitvalue, -samplecode) %T>%
  (. %>% distinct(trait) %>%
     db_merge_into(db = specdb, table = 'trait_info', values = ., 
                   by = 'trait', id_colname = 'traitid')) %>%
  db_merge_into(db = specdb, table = 'trait_data', values = .,
                by = c('samplecode', 'trait'), id_colname = 'traitdataid')


