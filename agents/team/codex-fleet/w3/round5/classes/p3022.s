# n=5 model=out iset=I1 prefix14_class=3022
cmp P2, P3
cmovl S0, P2
cmovle P2, P3
cmovl P3, S0
mov S2, P0
cmp S2, P1
cmovg S2, P1
cmovg P1, P0
mov S1, P2
mov P0, P3
cmp S1, P1
cmovge S1, P1
cmovg P1, P2
cmp S2, P0
