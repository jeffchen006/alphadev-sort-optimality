# n=5 model=out iset=I1 prefix14_class=12492
mov S1, P0
cmp P2, S1
cmovg S1, P2
mov S2, P1
cmovle P0, P2
cmp P3, P1
cmovle P1, P3
cmovl P3, S2
cmp P1, P0
cmovg P2, P0
mov S0, S1
cmovge P0, P1
cmovg P1, P2
cmp P3, S0
