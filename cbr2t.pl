#############################################
# �N cbr ���ͪ� html ���ন��r�ɵ��j��
# �S���հ�, �S���歺, ���̭��, ��ڥ� unicode 
# �ʦr����: unicode(�t 3.1), �q��, �զr
# �u�έ׭q���r
#############################################

$vol = shift;
#exit if $vol eq "";

$big5='(?:(?:[\x80-\xff][\x40-\xff])|(?:[\x00-\x7f]))';

# �ӷ��ؿ�, �]�N�O cbreader ���ͪ� html �ɥؿ�
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
		if(/<hr>�i�g���T�j(.*?)<br>/)
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

		# name="0016b19" id="0016b19"><span class="linehead">T01n0001_p0016b19��</span>
		# �h�Y�h��
		
		s/^name=.*?>//;
		s/<a \n//;
		s/��lac�F//g;
		s/<p>�@<span class="lg">/\n\n�@/g;
		s/<p><span class="lg">/\n\n/g;
		s/<p.*?>/\n\n�@�@/g;
		
		s#<span class="corr">(.*?)</span>#$1#g;		# �]���аO���_��, �ҥH�n���B�z
		s/<img src="[^>]*\\([^>]*gif)">/:1:figure entity="$1"\/:2:/g; 	# <img src="C:\cbeta\CBReader\Figures\T\T18014601.gif">
		s/<br>/\n/g;
		s/<[^<]*?>//g;		# �h�аO
		s/<[^<]*?>//g;		# �h�аO
		s/<[^<]*?>//g;		# �h�аO
		
		s/:1:fig/<fig/g;
		s/"\/:2:/"\/>/g;
		print OUT;
	}
}