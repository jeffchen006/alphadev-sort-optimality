# n=5 model=out iset=I1 prefix14_class=10104
mov S0, P2
mov S1, P3
cmp P0, P2
cmovg P2, P0
cmovg P0, S0
cmovl S0, P0
cmp S1, P1
cmovge P3, P1
cmovg P1, S1
cmp P2, P1
cmovle S1, P2
cmovl P2, P1
cmovle P1, S1
cmp P3, S0
