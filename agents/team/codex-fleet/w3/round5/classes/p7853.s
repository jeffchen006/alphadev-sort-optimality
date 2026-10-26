# n=5 model=out iset=I1 prefix14_class=7853
mov S0, P3
cmp P2, P3
cmovle S0, P2
cmovge P3, P2
cmp P1, P0
cmovl P2, P1
cmovge P2, P0
cmovge P0, P1
cmp P2, S0
cmovle P1, P2
cmovle P2, S0
cmovl S0, P1
cmp P3, P0
cmovl P1, P3
