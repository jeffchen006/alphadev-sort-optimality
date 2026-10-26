# n=5 model=out iset=I1 prefix14_class=8684
cmp P2, P1
cmovle S2, P1
mov S1, P3
cmovle P1, P2
cmovle P2, S2
cmp P0, P3
cmovl S1, P0
cmovl P0, P3
mov P3, P2
cmp P0, P2
cmovge P2, P0
cmovle P3, P0
mov S0, P1
cmp S1, S0
