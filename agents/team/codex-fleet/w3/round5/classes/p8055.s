# n=5 model=out iset=I1 prefix14_class=8055
mov S2, P2
cmp P3, P2
cmovle S2, P3
mov S1, S2
cmovle P3, P2
mov S0, P1
cmp S0, P0
cmovge S0, P0
cmovg P0, P1
cmp S1, S0
cmovl S2, S0
cmovg S1, S0
cmp P3, P0
cmovge P2, P3
