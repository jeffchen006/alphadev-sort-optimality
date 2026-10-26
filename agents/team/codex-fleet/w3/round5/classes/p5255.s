# n=5 model=out iset=I1 prefix14_class=5255
cmp P0, P3
mov S1, P0
cmovge P0, P3
cmovge P3, S1
mov S0, P2
cmp P1, P2
cmovle P2, P1
cmovl P1, S0
mov S2, P2
cmp P0, P2
cmovle S2, P0
cmovg P2, P0
cmp P1, P3
cmovle S1, P3
