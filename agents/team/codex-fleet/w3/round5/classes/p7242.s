# n=5 model=out iset=I1 prefix14_class=7242
cmp P1, P0
mov S2, P0
cmovle P0, P1
cmovg S2, P1
cmp P2, P3
mov S1, P0
cmovle S0, P3
cmovle P3, P2
cmovge S0, P2
cmp P3, P0
cmovg P0, P3
cmovl S1, P3
mov S1, P0
cmp S2, S0
