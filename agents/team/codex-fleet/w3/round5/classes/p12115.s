# n=5 model=out iset=I1 prefix14_class=12115
mov S1, P3
cmp P0, P2
cmovle S2, P2
cmovle P2, P0
cmovle P0, S2
cmp S1, P1
cmovl S1, P1
cmovl P1, P3
cmovge P3, P1
cmp P1, P2
cmovle P1, P2
cmovge P3, P2
mov S0, S1
cmovge P2, P1
