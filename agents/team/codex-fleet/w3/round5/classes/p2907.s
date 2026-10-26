# n=5 model=out iset=I1 prefix14_class=2907
mov S0, P0
cmp P2, P0
cmovl S0, P2
mov S1, P1
cmovge P0, P2
cmp P3, P1
cmovge P1, P3
mov P2, P0
cmovg P3, S1
cmp P1, P2
cmovl P2, P1
cmovle P1, P0
cmp S0, P3
cmovle S2, S0
