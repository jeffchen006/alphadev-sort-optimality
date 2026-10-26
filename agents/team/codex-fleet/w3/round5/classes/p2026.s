# n=5 model=out iset=I1 prefix14_class=2026
cmp P0, P2
mov S0, P2
mov S1, P1
cmovge P2, P0
cmovg P0, S0
cmp P3, S1
cmovge S1, P3
cmovl P1, P3
cmp S1, P2
mov S2, P0
cmovg P3, P2
cmovge P2, S1
cmovle P3, S1
cmp P1, S2
