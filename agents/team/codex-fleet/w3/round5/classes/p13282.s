# n=5 model=out iset=I1 prefix14_class=13282
cmp P2, P3
cmovg S2, P2
cmovg P2, P3
cmovg P3, S2
mov S0, P0
cmp S0, P1
cmovge S0, P1
cmovl P0, P1
mov S1, P0
cmp S0, P2
mov P1, S0
cmovg S0, P2
cmovle P1, P2
cmovge P2, P1
