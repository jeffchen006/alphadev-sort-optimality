# n=5 model=out iset=I1 prefix14_class=8984
cmp P3, P2
cmovg S0, P2
cmovg P2, P3
mov S2, P0
cmovg P3, S0
cmp S2, P1
cmovge S2, P1
cmovle P0, P1
cmovg P1, P0
cmp P2, P0
cmovge P0, P2
cmovl P1, P2
mov S1, P1
mov P0, S2
