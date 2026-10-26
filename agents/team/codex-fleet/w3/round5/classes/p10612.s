# n=5 model=out iset=I1 prefix14_class=10612
mov S2, P1
cmp P2, S2
cmovge P1, P2
cmovl S2, P2
mov S1, P3
cmp P3, P0
cmovg S1, P0
cmovle P3, P0
cmp P3, P1
cmovle S0, P1
cmovl P1, P3
mov P0, S2
cmovl P3, S0
cmp S1, S2
