# n=5 model=out iset=I1 prefix14_class=7058
mov S2, P2
cmp P0, P2
cmovg S2, P0
cmovg P0, P2
cmp P3, P1
cmovge S1, P3
cmovge P3, P1
cmovge P1, S1
cmp P3, P0
mov S0, P3
mov P2, S2
cmovle P3, P0
cmovl P0, S0
cmp S2, P1
