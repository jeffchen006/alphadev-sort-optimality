# n=5 model=out iset=I1 prefix14_class=11248
mov S0, P1
cmp P1, P3
cmovg S0, P3
mov S2, P2
cmovle P1, P3
cmp P2, P0
cmovl P2, P0
cmovge S2, P0
mov S1, S0
cmp P1, P2
cmovge P3, P2
cmovge P2, P1
cmovge P1, P3
cmp S0, S2
