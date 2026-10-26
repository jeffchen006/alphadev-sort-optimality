# n=5 model=out iset=I1 prefix14_class=11276
mov S0, P3
cmp P0, P1
cmovg S1, P1
cmovle S1, P0
cmovl P0, P1
cmp P3, P2
cmovge P3, P2
cmovl S0, P2
cmp S0, P0
mov P1, P3
cmovle S2, P0
cmovle P0, S0
cmovle S0, S2
mov S0, P0
