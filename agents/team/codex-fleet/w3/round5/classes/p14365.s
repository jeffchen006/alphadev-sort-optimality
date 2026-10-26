# n=5 model=out iset=I1 prefix14_class=14365
mov S1, P3
cmp S1, P2
cmovg S1, P2
cmovle P3, P2
cmp P0, P1
cmovge P2, P0
cmovg P0, P1
cmovge P1, P2
mov S2, S1
cmp S2, P0
cmovl S1, P0
mov S0, P3
cmovl P0, S2
cmovle S2, S1
