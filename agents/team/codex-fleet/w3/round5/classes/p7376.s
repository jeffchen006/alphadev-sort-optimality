# n=5 model=out iset=I1 prefix14_class=7376
mov S2, P1
cmp P1, P3
cmovle P1, P3
cmovl P3, S2
cmp P0, P2
mov S1, P3
mov S0, P2
cmovge P2, P0
cmovle S0, P0
cmp P3, S0
cmovg P3, S0
cmovle S1, S0
cmp P1, P2
cmovl S0, P2
