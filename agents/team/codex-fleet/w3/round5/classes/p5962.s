# n=5 model=out iset=I1 prefix14_class=5962
cmp P1, P0
cmovg S2, P1
cmovle S2, P0
cmovle P0, P1
mov P1, P3
cmp P1, P2
cmovg P3, P2
cmovl P1, P2
mov S0, P1
cmp S0, S2
cmovl S0, S2
cmovge P1, S2
cmp P3, P0
cmovle S2, P0
