# n=5 model=out iset=I1 prefix14_class=6121
cmp P1, P0
cmovle S1, P0
cmovl P0, P1
cmovge S1, P1
cmp P3, P2
cmovge S0, P2
cmovg P2, P3
cmovg P3, S0
mov P1, S1
cmp S1, P2
cmovge P1, P2
cmovg P2, S1
cmp P3, P0
mov P2, P0
