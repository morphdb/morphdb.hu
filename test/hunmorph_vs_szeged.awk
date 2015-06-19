## ez megnezi, hogy egy szora adott elemzesekbol, van-e olyan, ami
## megfelel a szegeden hozzarendelthez
## konkretan egy mezot ad a fajlhoz, ami X-Z alaku, ahol X (0 | 1 ) hogy
## eltalalta-e a hunmorph a gold standard annotaciot, Z pedig, h hany elemzest adott a hunmorph
## (ez konkretan a $6 egyebkent)
##
## ezutan grep "0-0$" az OOV szavakat adja pl.
## erdemes normalizalt KR-t beadni

{
	msdkr = $5;
	egyezes = 0;
	for(i =1 ; i <= $6; i++) {
		kr =  $(i + 6) ;
			
		if(msdkr == kr) {
			egyezes += 1;
		}
	} 

	
	code = egyezes "-" $6;

	print $0 "\t" code;

}
