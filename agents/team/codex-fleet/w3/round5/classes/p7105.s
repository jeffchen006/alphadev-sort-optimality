# n=5 model=out iset=I1 prefix14_class=7105
cmp P3, P1
cmovle S1, P1
cmovle P1, P3
cmovle P3, S1
cmp P0, P2
mov S2, P0
cmovl S2, P2
cmovl P2, P0
cmp P1, P2
mov S0, P1
cmovg P1, P2
cmovle S0, P2
cmp S2, P3
cmovge P2, P3
