# n=5 model=out iset=I1 prefix14_class=9337
mov S1, P3
cmp P1, P3
cmovle S1, P1
cmovge P3, P1
cmp P2, P0
cmovle S0, P0
cmovl P0, P2
cmovle P2, S0
mov P1, S1
cmp P1, P0
cmovg P1, P0
cmovge P0, S1
cmovl S1, P0
cmp P3, P2
