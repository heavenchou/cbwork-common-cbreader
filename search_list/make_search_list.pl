# �o�O�n���X bulei_sutra_sch.lst �� sutra_sch.lst , �o�G�ӭn��b CBReader �D�ؿ�, 
# �D�n�O�����˯���g��ܪ��C��.

# �@�k:
# ��Ū�� ../TaishoMenu_b5.txt �� ../XuzangjingMenu_b5.txt
# 1. �@��O���U�g����� $sutra{"Txxxx"} , �@��̮榡���X sutra_sch.lst
# 2. �AŪ�� ../bulei/bulei1_orig.txt , �̦��榡�A�t�X $sutra{"Txxnxxxx"} ���, ���X bulei_sutra_sch.lst

require "../../bin/cbetasub.pl";

open OUT , ">sutra_sch.lst";
make_vol("../TaishoMenu_b5.txt",3);	# "T", "�j����", �̫�@�ӰѼƬO���X�h, �Y�����O, �h�� 3 �h, �S�����N�G�h
make_vol("../XuzangjingMenu_b5.txt",3); #"X", "�sġ������", 
make_vol("../JiaXingZangMenu_b5.txt",2); #"J", "�ſ���(�s���ת�)", 
make_vol("../OthersMenu_b5.txt",2); #"", "�ɿ�", 
make_vol("../ZangWaiMenu_b5.txt",2); #"W", "�å~��Ф��m", 
make_vol("../ZhengShiMenu_b5.txt",2); #"H", "���v��и�����s", 
make_vol("../BaiPinMenu_b5.txt",2); #"I", "�_�¦�ݦʫ~", 
close OUT;

open OUT , ">bulei_sutra_sch.lst";
make_bulei();
close OUT;
print "\nOK, any key exit\n";
<>;

sub make_vol
{
	my $source = shift;
	my $level = shift;
	my $space_bu, $space_vol, $space_sutra;
	
	# �����O
	if($level == 3)
	{
		$space_bu = "\t";
		$space_vol = "\t\t";
		$space_sutra = "\t\t\t";
	}
	elsif($level == 2)
	{
		# �u���G�h, �S����
		$space_bu = "";
		$space_vol = "\t";
		$space_sutra = "\t\t";
	}
	
	#print OUT "$bookname\n";
	
	my $book = "";
	my $bookname = "";
	my $bu = "";
	my $vol = "";
	
	open IN, "$source" or die "open $source error. $!";
	<IN>;	# �Ĥ@��O�ƶq, ���n�z�L
	
	while(<IN>)
	{
		chomp;
		# 01,���t��,0001 , 22,�����t�g ,�i�᯳ ����C�٦@�Ǧ��Ķ�j
		# 01,�L�׼��z ,0001, 1  ,��ı�g�H�� ,�i�j
		# T,01,���t��,0001 , 22,�����t�g ,�i�᯳ ����C�٦@�Ǧ��Ķ�j
		# X,01,�L�׼��z ,0001, 1  ,��ı�g�H�� ,�i�j
		@data = split(/\s*,\s*/);
		$samebook = 1;
		$samebu = 1;
		if($data[0] ne $book)
		{
			$samebook = 0;	# �Ѧ���s, �����n��s
			$book = $data[0];
			$bookname = get_book_short_name_by_TX($book);	# cbetasub.pl
			print OUT "$bookname\n";
		}		
		if(($data[2] ne $bu) or ($samebook == 0))	# ����, �άO����
		{
			$samebu = 0;	# ������s, �U�@�w�n��s
			$bu = $data[2];
			print OUT "$space_bu$bu\n" if($bu ne "");
		}
		if(($data[1] ne $vol) or ($samebu == 0))
		{
			$vol = $data[1];
			print OUT "$space_vol${book}${vol}\n";
		}
		# �O���U��
		$sutra = $book . $data[3];
		$data = $data[5] . " (" . $data[4] . "��)" . $data[6];
		
		$vol{$sutra} = $book . $data[1];
		$sutra{$sutra} = $data;

		print OUT "$space_sutra${book}" . $data[1] . "n" . $data[3] . " " . $data . "\n";
	}
	close IN;
}

sub make_bulei
{
	open IN, "../bulei/bulei1_orig.txt";

	while(<IN>)
	{	
		$j = 0;
		$k = 0;
		chomp;
		
		$k=1 if(/^\s+[TXJHWIABCFGKLMPQSU][AB]?\d{3,4}[a-z]?\s/i);

		/^(\s*)(\S+)(.*)/;
		$space = $1;
		$sutra = $2;
		$tail = $3;
		
		if($vol{$sutra} && $sutra{$sutra})	# ��ܳo�O��g, ���O�𪬪��W�h
		{
			#print OUT $space . $sutra . "" . $tail . "\n";
			$tmp = substr($sutra,1);
			print OUT $space . $vol{$sutra} . "n" . $tmp . " " . $sutra{$sutra} . "\n";
			$j=1;
		}
		else
		{
			print OUT "$_\n";
		}
		if($j != $k)
		{
			print "$_\n";	# $j=1 ��ܦ��g���������, $k=1 ��� bulei1_orig.txt �榡�O [TX]xxxx[a-z] �o��, �G�����P�B
		}
	}
	close IN;
}



