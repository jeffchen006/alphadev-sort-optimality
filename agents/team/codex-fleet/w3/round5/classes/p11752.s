# n=5 model=out iset=I1 prefix14_class=11752
cmp P2, P1
cmovge S1, P2
cmovg P2, P1
cmovg P1, S1
mov S0, P1
cmp P3, P0
mov S2, P3
cmovge S2, P0
cmovle P3, P0
cmp P3, S0
cmovg S0, P3
cmovl P1, P3
mov P3, P2
cmp S2, P2
