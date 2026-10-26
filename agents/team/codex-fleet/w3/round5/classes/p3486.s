# n=5 model=out iset=I1 prefix14_class=3486
mov S1, P1
cmp P0, P1
cmovg S1, P0
cmovg P0, P1
mov S0, P3
cmp S0, P2
cmovl P3, P2
cmovle P2, S0
mov S0, P0
cmp P2, S0
cmovge S0, P2
cmovg P2, P0
mov P2, S1
cmp P2, P3
