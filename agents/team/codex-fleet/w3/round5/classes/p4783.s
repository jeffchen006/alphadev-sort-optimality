# n=5 model=out iset=I1 prefix14_class=4783
cmp P0, P1
cmovl S1, P0
cmovle P0, P1
cmovl P1, S1
cmp P2, P3
cmovg S2, P2
cmovge P2, P3
cmovle S2, P3
mov S0, P0
mov P3, P1
cmp P2, P1
cmovge P3, P2
cmovle P1, P2
cmp S0, S2
