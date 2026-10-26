# n=5 model=out iset=I1 prefix14_class=1362
cmp P3, P2
cmovge S1, P2
cmovg P2, P3
cmovl S1, P3
cmp P0, P1
cmovge S0, P1
mov P3, P2
cmovle S0, P0
cmovg P1, P0
cmp P1, P2
cmovge P3, P1
cmovge P1, P2
cmp S1, S0
cmovle P2, S0
