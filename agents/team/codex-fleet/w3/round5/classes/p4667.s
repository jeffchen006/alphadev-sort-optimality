# n=5 model=out iset=I1 prefix14_class=4667
mov S0, P3
cmp P1, P3
mov S1, P0
cmovg P3, P1
cmovge P1, S0
cmp P2, S1
cmovle P0, P2
mov S2, P0
cmovl P2, S1
cmp P2, P3
cmovg S0, P3
cmovg P3, P2
cmovg P2, S0
cmp P0, P1
