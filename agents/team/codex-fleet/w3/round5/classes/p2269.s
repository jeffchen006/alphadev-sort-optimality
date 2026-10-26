# n=5 model=out iset=I1 prefix14_class=2269
mov S0, P2
cmp P0, P1
cmovg S1, P0
cmovle S1, P1
cmovge P0, P1
cmp S0, P3
cmovl P2, P3
mov P1, P2
cmovg S0, P3
cmp P2, S1
cmovle P1, S1
cmovl S1, P2
cmp P0, S0
cmovge P3, P0
