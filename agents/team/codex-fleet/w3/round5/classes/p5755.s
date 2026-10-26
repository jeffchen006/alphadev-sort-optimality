# n=5 model=out iset=I1 prefix14_class=5755
cmp P0, P1
cmovg S0, P0
cmovle S0, P1
cmovge P0, P1
mov S2, P3
mov S1, P0
cmp S2, P2
cmovge S2, P2
cmovg P2, P3
cmp S2, S1
cmovle P0, S2
cmovl S2, S1
mov S1, S2
mov P0, S0
