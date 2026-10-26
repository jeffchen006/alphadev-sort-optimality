# n=5 model=out iset=I1 prefix14_class=10014
cmp P2, P3
cmovl S1, P2
cmovge S1, P3
cmovge P3, P2
cmp P1, P0
mov S2, S1
mov P2, P0
cmovge P0, P1
cmovg P1, P2
cmp P0, P3
cmovle S0, P0
cmovle P0, P3
cmovl P3, S0
cmp S1, P1
