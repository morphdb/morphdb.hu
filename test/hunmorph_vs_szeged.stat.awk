## ez megnezi, hogy egy szora adott elemzesekbol, van-e olyan, ami
## megfelel a szegeden hozzarendelthez
## konkretan egy mezot ad a fajlhoz, ami X-Z alaku, ahol X (0 | 1 ) hogy
## eltalalta-e a hunmorph a gold standard annotaciot, Z pedig, h hany elemzest adott a hunmorph
## (ez konkretan a $6 egyebkent)
##
## ezutan grep "0-[0-9]$" az OOV szavakat adja pl.
## erdemes normalizalt KR-t beadni

{
	
	code = $($6 + 7);
	egyezes = substr(code, 0, 1);
	difkr = substr(code, 3, 2);


	key = "";

	if(egyezes == 0) {
           if ( difkr == 0) {
		key = "oov";
	   } else {
                key = "confused";
           }
        } else {
	   if (difkr == egyezes) {
               key = "exact";
           } else {
	       key = "ambig";
           }
        }

	token[key] += $1;
	type[key] += 1;
	
	tokensum += $1;
	typesum += 1;
} END {
	for (code in token) {
		printf( "%-9s %6s \t %3.4f %6s \t %3.4f\n", code, token[code], (token[code] / tokensum)* 100, type[code], (type[code]/typesum) * 100); 
	}
}
