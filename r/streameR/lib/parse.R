rename_cols <- function(df) {
	for (i in 1:ncol(df)) {
		colnames(df)[i] <- paste(
			"V",
			i,
			sep=""
		) 
	}
	return (df)
}

parse_flat <- function(source_type, msg, sep_txt) {
	sep_txt <- paste (
		"[",
		sep_txt,
		"]",
		sep=""
	)
	split_msg<- strsplit(msg, sep_txt)
	temp_df <- as.data.frame(
		do.call(
			"rbind",
			split_msg
		), 
		stringsAsFactors = FALSE
	)	
	temp_df <- rename_cols(temp_df)
	return (temp_df)
}

parse_json <- function(source_type, msg) {
	raw_msg <- fromJSON(msg)	
	temp_df <- data.frame(
		raw_msg, 
		check.names = FALSE,
		stringsAsFactors=FALSE
	)	
	temp_df <- rename_cols(temp_df)
	return (temp_df)
}