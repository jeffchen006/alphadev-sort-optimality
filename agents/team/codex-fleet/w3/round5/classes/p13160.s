# n=5 model=out iset=I1 prefix14_class=13160
mov S2, P3
mov S1, P0
cmp P3, P2
cmovl P3, P2
cmovg S2, P2
cmp S1, P1
cmovle P0, P1
cmovg S1, P1
cmp S1, S2
cmovge S0, S1
cmovge S1, S2
mov P2, P0
cmovge S2, S0
cmp P3, P2
