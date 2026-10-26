# n=5 model=out iset=I1 prefix14_class=4281
mov S0, P3
cmp P2, P3
cmovge S0, P2
cmovge P2, P3
mov P3, P0
cmp P3, P1
cmovg P0, P1
cmovle P3, P1
cmp P2, P0
cmovle P1, P0
cmovle P0, P2
cmovge P1, P2
cmp P3, S0
cmovl P2, S0
