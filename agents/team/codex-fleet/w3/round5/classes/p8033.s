# n=5 model=out iset=I1 prefix14_class=8033
mov S1, P2
cmp P2, P1
cmovge P2, P1
mov S0, P0
cmovl S1, P1
cmp S0, P3
cmovle P0, P3
cmovg S0, P3
cmp S0, P2
cmovle S2, P2
cmovl P2, S0
mov P2, S1
cmovle S0, S2
cmp P0, P2
