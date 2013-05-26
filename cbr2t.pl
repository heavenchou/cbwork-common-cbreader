#############################################
# 將 cbr 產生的 html 檔轉成文字檔給大陸
# 沒有校勘, 沒有行首, 不依原書, 梵巴用 unicode 
# 缺字順序: unicode(含 3.1), 通用, 組字
# 只用修訂的字
#############################################

$vol = shift;
#exit if $vol eq "";

$big5='(?:(?:[\x80-\xff][\x40-\xff])|(?:[\x00-\x7f]))';

# 來源目錄, 也就是 cbreader 產生的 html 檔目錄
$source_path = "c:/release/cbr_out/";
$outpath = "c:/release/cbr_out_txt/" . $vol;
mkdir($outpath);

$filename = "$source_path${vol}/*.htm";
@files = <${filename}>;
#open OUT, ">${vol}_cbr.txt";

foreach $file (sort(@files))
{
	my $outfile = $file;
	$outfile =~ s/\.htm/.txt/;
	$outfile =~ s/cbr_out/cbr_out_txt/;
	
	open IN, $file;
	open OUT, ">$outfile";
	while(<IN>)
	{
		if(/<hr>【經文資訊】(.*?)<br>/)
		{
			print OUT "$1\n";
			last;
		}
	}
	close IN;
	
	open IN, $file;
	h2t();
	close IN;
	close OUT;
}

###########################

sub h2t()
{
	local $_;
	
	while(<IN>)
	{
		next unless (/^name="\d{4}.\d\d"/);

		# name="0016b19" id="0016b19"><span class="linehead">T01n0001_p0016b19║</span>
		# 去頭去尾
		
		s/^name=.*?>//;
		s/<a \n//;
		s/＆lac；//g;
		s/<p>　<span class="lg">/\n\n　/g;
		s/<p><span class="lg">/\n\n/g;
		s/<p.*?>/\n\n　　/g;
		
		s#<span class="corr">(.*?)</span>#$1#g;		# 因為標記有巢狀, 所以要先處理
		s/<img src="[^>]*\\([^>]*gif)">/:1:figure entity="$1"\/:2:/g; 	# <img src="C:\cbeta\CBReader\Figures\T\T18014601.gif">
		s/<br>/\n/g;
		s/<[^<]*?>//g;		# 去標記
		s/<[^<]*?>//g;		# 去標記
		s/<[^<]*?>//g;		# 去標記
		
		s/:1:fig/<fig/g;
		s/"\/:2:/"\/>/g;
		print OUT;
	}
}