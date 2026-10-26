# n=5 model=out iset=I1 prefix14_class=6118
cmp P1, P2
cmovl S1, P2
cmovle P2, P1
cmovge S1, P1
cmp P0, P3
cmovg P1, P3
cmovg P3, P0
cmovg P0, P1
mov P1, S1
cmp P1, P3
cmovge P1, P3
cmovg P3, S1
cmp P0, P2
cmovle S0, P0
