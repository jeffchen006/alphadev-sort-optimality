# n=5 model=out iset=I1 prefix14_class=13687
mov S2, P2
cmp P2, P3
cmovg S2, P3
mov S0, P1
cmovle P2, P3
mov S1, S2
cmp P1, P0
cmovge S0, P0
cmovl P1, P0
cmp P1, P2
cmovge P3, P2
cmovge P2, P1
cmovge P1, P3
cmp S2, S0
