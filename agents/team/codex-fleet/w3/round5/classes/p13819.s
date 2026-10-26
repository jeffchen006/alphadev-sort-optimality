# n=5 model=out iset=I1 prefix14_class=13819
mov S0, P1
mov S1, P3
cmp P0, S1
cmovge S1, P0
cmovge P0, P3
cmp P2, S0
cmovg P1, P2
cmovl S0, P2
cmp S1, P1
cmovle S2, S1
cmovl S1, P1
cmovge S2, P1
cmp P0, S0
cmovle P2, S0
