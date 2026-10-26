# n=5 model=out iset=I1 prefix14_class=923
mov S0, P2
cmp P1, S0
cmovle P2, P1
mov S1, P0
cmovge S0, P1
cmp S1, P3
cmovg S1, P3
cmovg P3, P0
mov P1, S1
mov S2, S0
cmp P3, S2
cmovge S0, P3
cmovl S2, P3
cmovg P3, S2
