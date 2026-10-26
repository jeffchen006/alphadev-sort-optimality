# n=5 model=out iset=I1 prefix14_class=7411
cmp P0, P1
mov S0, P0
cmovg P0, P1
cmovl S0, P1
cmp P2, P3
cmovle S2, P2
mov S1, P0
cmovge S2, P3
cmovge P3, P2
cmp S1, S2
cmovle P0, S2
cmovg S1, S2
cmp S0, P3
cmovge S1, S0
