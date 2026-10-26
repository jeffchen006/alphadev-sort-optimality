# n=5 model=out iset=I1 prefix14_class=14507
cmp P1, P0
cmovg S0, P0
cmovg P0, P1
cmovg P1, S0
cmovle S0, P1
cmp P2, P3
cmovle S1, P3
cmovle P3, P2
cmovle P2, S1
cmp P1, P3
cmovl P1, P3
cmovl P3, S0
cmp P0, P2
cmovge P3, P2
