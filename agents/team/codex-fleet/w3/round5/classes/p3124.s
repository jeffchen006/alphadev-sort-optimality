# n=5 model=out iset=I1 prefix14_class=3124
cmp P0, P3
cmovg S0, P3
mov S1, P2
cmovg P3, P0
cmovle S0, P0
cmp P1, P2
cmovg S1, P1
cmovle P2, P1
mov S2, S0
cmp S0, P2
cmovge S2, P2
mov S2, P3
cmovl S0, P2
cmp S1, P3
