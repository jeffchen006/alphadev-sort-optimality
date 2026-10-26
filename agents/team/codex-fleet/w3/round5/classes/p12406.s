# n=5 model=out iset=I1 prefix14_class=12406
mov S1, P3
cmp P1, S1
cmovge P3, P1
mov S2, P0
cmovl S1, P1
cmp P2, S2
cmovle P0, P2
cmovg S2, P2
cmp S1, P0
cmovle S0, P0
cmovl P0, S1
cmovle S1, S0
cmp S2, P3
mov P1, S2
