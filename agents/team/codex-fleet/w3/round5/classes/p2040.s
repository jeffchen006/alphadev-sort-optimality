# n=5 model=out iset=I1 prefix14_class=2040
mov S0, P3
cmp P0, P3
cmovge P3, P0
cmovg P0, S0
mov S0, P0
cmp P1, P2
cmovge S1, P1
cmovge P1, P2
cmovge P2, S1
mov S2, P2
cmp P2, P3
cmovle P2, P3
cmovge S2, P3
cmovl P3, S2
