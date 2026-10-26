# n=5 model=out iset=I1 prefix14_class=1869
mov S2, P3
cmp P1, P3
mov S1, P0
cmovl P3, P1
cmovle P1, S2
cmp P2, P0
cmovle S1, P2
cmovge P0, P2
mov S2, P1
cmp P0, S2
cmovl P1, P0
cmovle P0, S2
cmp P3, S1
cmovl S0, P3
