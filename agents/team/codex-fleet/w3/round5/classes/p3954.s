# n=5 model=out iset=I1 prefix14_class=3954
mov S0, P0
cmp S0, P1
cmovl S0, P1
cmovg P0, P1
mov P1, P0
cmp P2, P3
cmovg S2, P2
cmovle S2, P3
cmovle P3, P2
cmp P3, P0
cmovle P1, P3
cmovge P0, P3
cmp S0, S2
cmovge P3, S0
