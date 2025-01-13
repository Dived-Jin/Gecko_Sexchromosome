mkdir gene.lst
cat speciesV1.orderV2.add.tab | awk '/ZW/ || /XY/ || /TSD/' | cut -f2 | while read i
do
	echo "perl bin/pick.column_info.pl chr.lst/$i.list ../00.data/$i/$i.gff.bed.sort.add_idx 1 1 -t same > gene.lst/$i.gene.tab"
done > prepare.sh
sh prepare.sh

