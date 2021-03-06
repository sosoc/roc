.L2swathnames <- function() {
  c("longitude", "latitude", "aot_865", "angstrom", "Rrs_412", 
    "Rrs_443", "Rrs_490", "Rrs_510", "Rrs_555", "Rrs_670", "chlor_a", 
    "Kd_490", "pic", "poc", "cdom_index", "par", "l2_flags")
}

.L2metanames <- function() {
  c( "orb_vec", 
     "sun_ref", "att_ang", "sen_mat", "scan_ell", "nflag", "tilt_ranges"
  )
}

.L2template <- function() {
  'HDF5:%s_L2:"%s":%i'
}

#' @importFrom tibble as_tibble
#' @importFrom raster stack
readL2 <- function(file, vartype = c("swath", "meta"), data.frame = TRUE) {
  vartype <- match.arg(vartype)
  sds <- switch(vartype, 
                swath = .L2swathnames(), 
                meta = .L2metanames())
  sdsoffset <- switch(vartype, 
                      swath = 10, 
                      meta = 35)
  bx <- basename(file)
  sdspaths <- sprintf(.L2template(), .filesensor(bx), file, seq_along(sds) + sdsoffset)
  
  s1 <- stack(sdspaths, quick = TRUE)  
  names(s1) <- sds
  
  if (data.frame) {
    ## s1 <- values(s1)
    ##  s1 <- lapply(seq(ncol(s1)), function(x) s1[,x])
    ##  names(s1) <- sds
    s1 <- lapply(seq(raster::nlayers(s1)), function(x) raster::values(s1[[x]]))
    names(s1) <- sds
    s1 <- tibble::as_tibble(s1)
  }
  s1
}
