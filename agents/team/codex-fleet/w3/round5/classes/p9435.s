# n=5 model=out iset=I1 prefix14_class=9435
mov S0, P3
cmp P1, S0
cmovl S0, P1
cmovl P1, P3
cmp P0, P2
cmovge P3, P0
cmovle P3, P2
cmovge P0, P2
cmp S0, P0
cmovg P2, P0
cmovg P0, S0
cmovle P2, S0
cmp P1, P3
cmovle S1, P3
