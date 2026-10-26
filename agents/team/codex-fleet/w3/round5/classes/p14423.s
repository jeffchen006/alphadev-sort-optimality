# n=5 model=out iset=I1 prefix14_class=14423
cmp P1, P2
cmovle S1, P1
cmovle P1, P2
cmovg S1, P2
cmp P0, P3
cmovge P2, P0
cmovle P2, P3
cmovle P3, P0
cmp P3, S1
cmovg S0, P3
cmovg P3, S1
cmovg S1, S0
cmp P2, P1
cmovl P0, P2
