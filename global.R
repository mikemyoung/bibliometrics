library(shiny)
library(shinydashboard)
library(DT)
library(tidyverse)
library(openxlsx)
library(plotly)
library(shinycssloaders)
library(shinysurveys)
library(googledrive)
library(googlesheets4)


options(
  # whenever there is one account token found, use the cached token
  gargle_oauth_email = TRUE,
  # specify auth tokens should be stored in a hidden directory ".secrets"
  gargle_oauth_cache = "bibliometrics/.secrets"
)

# Get the ID of the sheet for writing programmatically
# This should be placed at the top of your shiny app
sheet_id <- drive_get("bibliometrics_submit")$id


survey_questions <- data.frame(
  question = c("What is the DOI for your Antarctica New Zealand supported publication?",
               "What is your email?"),
  option = NA,
  input_type = "text",
  input_id = c("doi", "email"),
  dependence = NA,
  dependence_value = NA,
  required = c(TRUE, TRUE)
)

# Set spinner type (for loading)
options(spinner.type = 8)


antnz_totals_graph <- readRDS("data/antnz_totals_graph.rds")
antnz_citation_6y <- readRDS("data/antnz_citation_6y.rds")
percentPercentileData <- readRDS("data/percentPercentileData.rds")

antnzAcknowledged <- readRDS("data/antnzAcknowledge.rds")
antnzSupported <- readRDS("data/antnzSupported.rds")
asp <- readRDS("data/asp.rds")
totalAntnz <- readRDS("data/antnzTotal.rds")
antSci <- readRDS("data/antsci.rds")