# �ˬd bulei4_orig.txt ���S�����Ъ������øg��

open IN, "bulei4_orig.txt";		# ��o�@��]�i�H�ˬd bulei3_orig.txt
while(<IN>)
{
	if(/^\s*(X\d{4}[a-z]?)/i)
	{
		$tmp = $1;
		$hash{$tmp} = $hash{$tmp} + 1;
	}
}
$found = 0;
for $key (keys(%hash))
{
	if($hash{$key} > 1)
	{
		$found++;
		print "$key\n";
	}
}
if($found == 0)
{
	print "OK\n" ;
}
else
{
	print "Oh! NO Good , please check ....\n" ;
}

print "press any key exit...";
<>;
