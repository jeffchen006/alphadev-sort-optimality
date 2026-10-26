# n=5 model=out iset=I1 prefix14_class=2941
mov S2, P1
cmp S2, P0
mov S0, P2
cmovg P1, P0
cmovge P0, S2
cmp P3, P2
cmovg P2, P3
cmovge P3, S0
cmovg S0, P2
cmp P0, P2
cmovl P2, P0
cmovle P0, S0
cmp P1, P3
cmovg S1, P3
