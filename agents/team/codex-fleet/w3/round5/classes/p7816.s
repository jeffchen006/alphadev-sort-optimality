# n=5 model=out iset=I1 prefix14_class=7816
mov S2, P2
cmp P0, P2
cmovl P2, P0
cmovge S2, P0
cmp P1, P3
mov S0, P1
cmovge S0, P3
cmovg P3, P1
cmp S0, P2
cmovle P0, P2
mov P1, S2
cmovl P2, S0
cmovl S0, P0
mov S1, S0
