# n=5 model=out iset=I1 prefix14_class=10086
mov S0, P2
cmp P0, P2
cmovge S0, P0
cmovle P2, P0
mov S2, P3
cmp P3, P1
mov S1, S0
cmovg P3, P1
cmovle S2, P1
cmp S1, S2
cmovl S1, S2
cmovg S0, S2
cmp P3, P2
cmovge S2, S0
