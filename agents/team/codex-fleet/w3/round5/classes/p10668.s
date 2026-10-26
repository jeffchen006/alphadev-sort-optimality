# n=5 model=out iset=I1 prefix14_class=10668
mov S2, P2
cmp P1, P2
cmovle P2, P1
cmovl P1, S2
cmp P0, P3
mov S2, P0
cmovg S2, P3
cmovge P3, P0
cmp P1, P3
cmovge S0, P3
cmovg P3, P1
cmovge P1, S0
cmp P2, S2
cmovge S0, P2
