## fogja az MSD-bol atalakitott KR kodokat es a hunmorph kimeneti annotacioit es normalizalja
## lemmat eltunteti
## kivagja a szubkatokat
## kepzoket eltunteti
## igy lehet, h ket hunmorph kimenet megkulonboztethetelenne valik, ezeket osszevonja
## ket parametert var: kfield annak a mezonek a sorszama, ahol a hunmorph elemzesek
## szama szerepel

function strip_inflextion ( kr ) {
        k = split (kr, v, "?|/");
        if(k > 1) kr = v[k];
        
        return kr;
}

function normalize_KR ( kr ) {
	return strip_inflextion(kr);
}

BEGIN {
	FS="\t";
}
{
	if($kfield == "") {
		print $0;
	} else {
		difkr = 0;
		delete set;
		if(!onlyreplace) {
			for(i =1 ; i <= $kfield; i++) {
				kr = normalize_KR( $(i + kfield) );
				## normalizalas utan a hunmorphnak lehet, h ket kimenete ugyanaz

				if(set[kr] == "" ) {		
					set[kr] =kr;
					difkr += 1;
				} 
			}
		}
		for(i = 1; i < kfield; i++) {
			printf("%s\t", $i);
		}
		if(!onlyreplace) {
			printf("%d", difkr);
			for(l in set) {
				printf("\t%s", l);
			}
		} else {
			printf("%s", normalize_KR($kfield));
		}
		printf("\n");
	}
} 
