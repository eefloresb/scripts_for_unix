#!/usr/bin/perl
# Returns memory USED
# (c) 2017 Sancho Lerena <slerena@artica.es>
use POSIX;
my $STOTAL=`vmstat -s | grep "total swap" | awk  '{ print $1 } '`;
my $SUSED=`vmstat -s | grep "free swap" | awk  '{ print $1 } '`;
my $SFREE;
eval {
$SFREE=($SUSED/$STOTAL)*100;
};
if ($@) {
        $SFREE = 100;
}

$SFREE = floor($SFREE);
$FREEP = floor($FREEP);

# Available memory as FreeMemory + Cached + SwapCached.
my $freemem=`cat /proc/meminfo | grep 'MemFree' | awk '{ print \$2 } '`;
my $cached=`cat /proc/meminfo | grep '^Cached:' | awk '{ print \$2 } '`;
my $cachedswap=`cat /proc/meminfo | grep '^SwapCached:' | awk '{ print \$2 }'`;
my $total_meminfo=`cat /proc/meminfo | grep 'MemTotal:' | awk '{ print \$2 }'`;
my $available_new=`cat /proc/meminfo | grep 'MemAvailable:' | awk '{ print \$2 }'`;
my $available;
if ($available_new == 0){
        $available=$freemem+$cached+$cachedswap;
}else{
        $available=$available_new;
}
my $available_percent = floor(($available / $total_meminfo)*100);

my $USED = 100 - $available_percent;
my $SWAP_USED = 100 - $SFREE;

print "<module>\n";
print "<name><![CDATA[Memory_Used]]></name>\n";
print "<type><![CDATA[generic_data]]></type>\n";
print "<description><![CDATA[Used memory %]]></description>\n";
print "<unit><![CDATA[%]]></unit>\n";
print "<min_critical><![CDATA[95]]></min_critical>\n";
print "<max_critical><![CDATA[100]]></max_critical>\n";
print "<data><![CDATA[$USED]]></data>\n";
print "<module_group><![CDATA[System]]></module_group>\n";
print "</module>\n";

print "<module>\n";
print "<name><![CDATA[Swap_Used]]></name>\n";
print "<type><![CDATA[generic_data]]></type>\n";
print "<description><![CDATA[Used Swap %]]></description>\n";
print "<unit><![CDATA[%]]></unit>\n";
print "<min_critical><![CDATA[95]]></min_critical>\n";
print "<max_critical><![CDATA[100]]></max_critical>\n";
print "<data><![CDATA[$SWAP_USED]]></data>\n";
print "<module_group><![CDATA[System]]></module_group>\n";
print "</module>\n"
