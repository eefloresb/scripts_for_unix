svmon -Pt15 | perl -e 'while(<>){print if($.==2||$&&&!$s++);$.=0
if(/^-+$/)}'

