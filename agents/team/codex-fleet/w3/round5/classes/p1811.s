# n=5 model=out iset=I1 prefix14_class=1811
cmp P1, P3
mov S0, P3
cmovge P3, P1
cmovg P1, S0
cmp P2, P0
cmovg S1, P0
cmovge P0, P2
mov S0, P0
cmovg P2, S1
cmp P3, P0
cmovl P0, P3
mov S2, P1
cmovle P3, S0
cmp P2, S2
