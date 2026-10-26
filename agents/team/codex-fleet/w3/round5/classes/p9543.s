# n=5 model=out iset=I1 prefix14_class=9543
cmp P2, P3
mov S0, P0
mov S2, P3
cmovg P3, P2
cmovg P2, S2
cmp S0, P1
cmovge P0, P1
cmovl S0, P1
cmp P0, P2
cmovle S1, P0
cmovle P0, P2
cmovl P2, S1
cmp P3, S0
cmovle P1, S0
