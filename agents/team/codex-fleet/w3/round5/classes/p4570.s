# n=5 model=out iset=I1 prefix14_class=4570
cmp P3, P0
mov S0, P0
cmovge P0, P3
cmovl S0, P3
cmp P2, P1
cmovge S2, P2
cmovg P2, P1
cmovle S2, P1
cmp P0, S2
cmovge P1, S2
cmovg S2, P0
cmovle P1, P0
mov S2, P1
cmp S0, P2
