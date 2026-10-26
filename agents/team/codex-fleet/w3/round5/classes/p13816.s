# n=5 model=out iset=I1 prefix14_class=13816
cmp P1, P0
cmovl S0, P0
cmovge S0, P1
cmovg P1, P0
mov S2, P2
cmp P3, S2
cmovle P2, P3
cmovge S2, P3
cmp S2, S0
mov S1, P1
cmovg P3, S0
cmovge S0, S2
cmovg S2, P3
mov S0, S2
