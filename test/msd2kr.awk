BEGIN {
	FS="\t";
	if(ARGC < 5) {
		print "usage: awk -f msd2kr.awk msd2kr_table word_field msd_field" > "/dev/stderr";
		exit;
	}

# loading msd2kr file

	file = ARGV[1];
	while(getline < (file) ) {
		# comment figyelmen kivul hagyasa
		if(match($0, "^#")) {
			continue;
		}

		# MSD kodok vegerol levagja a - jeleket
		sub(/\-+$/, "", $1);
		if (msd2kr[$1] != "") {
			print "duplicated msd code: " $1 > "/dev/stderr";
		}
		msd2kr[$1] = $2;
	}
	close(file)
# szeged2morphd file

	file = ARGV[2];
        while(getline < (file) ) {
                # comment figyelmen kivul hagyasa
                if(match($0, "^#")) {
                        continue;
                }
		key = $1 $2;
                if (sz2m[key] != "") {
                        print "duplicated word+msd: " $1 $2 > "/dev/stderr";
                }
                sz2m[key] = $3;
        }
        close(file)
	while(getline < "/dev/stdin") {
		if($0 == "") {
			print "";
			continue;
		}
		word = $(ARGV[3]);
		msd = $(ARGV[4]);
		if (msd == "" || word == "") {
			print $0;
			continue;
		}
		key = word "" msd;
		// ha szo alapu transzformacio van
		kr = sz2m[key];
		if( kr == "") {
			kr  = msd2kr[msd];
		}
		if (kr == "" ) {
			kr = "<NO_KR>";
		}

		print $0 "\t" kr;
	}
	

}
