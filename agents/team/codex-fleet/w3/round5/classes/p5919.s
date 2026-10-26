# n=5 model=out iset=I1 prefix14_class=5919
cmp P3, P0
cmovg S2, P3
mov S1, P1
cmovle S2, P0
cmovge P3, P0
cmp P2, S1
cmovg S1, P2
cmovg P2, P1
cmp S1, S2
cmovle P0, S1
cmovle S1, S2
cmovl S2, P0
mov S0, S2
cmp P2, P3
