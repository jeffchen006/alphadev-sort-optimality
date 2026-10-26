# n=5 model=out iset=I1 prefix14_class=12057
mov S2, P3
cmp P0, P2
cmovge S0, P0
cmovg P0, P2
cmovg P2, S0
cmp P1, P3
cmovg S2, P1
cmovl P3, P1
mov P1, P3
cmp P0, P1
cmovle P3, P0
cmovge P1, P0
cmp S2, P2
cmovge S1, S2
